terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.4"
    }
  }
}

resource "kubernetes_config_map" "httpbin-configmap" {
  metadata {
    name      = "httpbin-${var.name}-configmap"
    namespace = var.name
  }

  data = {
    "httpbin.js" = <<EOF
import http from 'k6/http';
import { Gauge } from 'k6/metrics';

const duration      = new Gauge('test_config_duration');
const rate          = new Gauge('test_config_rate');
const virtual_users = new Gauge('test_config_virtual_users');

const scenarios = {
  "constant-vus": {
    executor: 'constant-vus',
    vus: ${var.config.virtual_users},
    duration: '${var.config.duration}m',
  },
  "ramping-vus": {
    executor: 'ramping-vus',
    stages: [...Array(${var.config.ramping_steps})].map((_, i) =>
      ({
        target: ${var.config.virtual_users} * ((i + 1) / ${var.config.ramping_steps}),
        duration: (${var.config.duration} * (1 / ${var.config.ramping_steps})) + "m",
      })
    ),
  },
  "constant-arrival-rate": {
    executor: 'constant-arrival-rate',
    duration: '${var.config.duration}m',
    rate: ${var.config.rate},
    timeUnit: '1s',
    preAllocatedVUs: ${var.config.virtual_users},
  },
  "ramping-arrival-rate": {
    executor: 'ramping-arrival-rate',
    startRate: 1000,
    timeUnit: '1s',
    preAllocatedVUs: ${var.config.virtual_users},
    stages: [ ...([...Array(${var.config.ramping_steps})].map((_, i) =>
      ({
        target: ${var.config.rate} * ((i + 1) / ${var.config.ramping_steps}),
        duration: '6s',
      })
    )), {
      target: ${var.config.rate},
      duration: (${var.config.duration} - ${var.config.ramping_steps} * 0.1) + "m",
    }],
  },
};

const { SCENARIO } = __ENV;
export const options = {
  discardResponseBodies: true,
  scenarios: { [SCENARIO]: scenarios[SCENARIO] },
};

export default function () {
  duration.add("${var.config.duration}");
  rate.add("${var.config.rate}");
  virtual_users.add("${var.config.virtual_users}");

  http.get('http://${var.url}/httpbin/status/' + status);
}
EOF
  }
}

resource "kubectl_manifest" "httpbin" {
  yaml_body = <<YAML
apiVersion: k6.io/v1alpha1
kind: K6
metadata:
  name: httpbin
  namespace: ${var.name}
spec:
  parallelism: ${var.config.parallelism}
  separate: false
  quiet: "false"
  cleanup: "post"
  arguments: --out experimental-prometheus-rw --tag testid=${var.name}-httpbin --env SCENARIO=${var.config.executor}
  initializer:
    metadata:
      labels:
        initializer: "k6"
    nodeSelector:
      node: ${var.name}-tests
    affinity:
      podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
        - topologyKey: kubernetes.io/hostname
          labelSelector:
            matchExpressions:
            - key: initializer
              operator: In
              values:
              - "k6"
        - topologyKey: kubernetes.io/hostname
          labelSelector:
            matchExpressions:
            - key: runner
              operator: In
              values:
              - "true"
  starter:
    nodeSelector:
      node: ${var.name}-tests
  runner:
    nodeSelector:
      node: ${var.name}-tests
    env:
    - name: K6_PROMETHEUS_RW_SERVER_URL
      value: http://prometheus-server.dependencies.svc:80/api/v1/write
    - name: K6_PROMETHEUS_RW_PUSH_INTERVAL
      value: 1s
    - name: K6_PROMETHEUS_RW_TREND_STATS
      value: p(90),p(95),p(99)
  script:
    configMap:
      name: httpbin-${var.name}-configmap
      file: httpbin.js
YAML

  depends_on = [kubernetes_config_map.httpbin-configmap]
}