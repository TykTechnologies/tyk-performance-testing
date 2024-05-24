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

const scenarios = {
  "constant-vus": {
    executor: 'constant-vus',
    vus: ${var.config.virtual_users},
    duration: '${var.config.duration}m',
  },
  "constant-arrival-rate": {
    executor: 'constant-arrival-rate',
    duration: '${var.config.duration}m',
    rate: ${var.config.rate},
    timeUnit: '1s',
    preAllocatedVUs: ${var.config.virtual_users}
  },
  "ramping-arrival-rate": {
    executor: 'ramping-arrival-rate',
    startRate: 1000,
    timeUnit: '1s',
    preAllocatedVUs: ${var.config.virtual_users},
    stages: [
      { target: (${var.config.rate} * 0.2), duration: '15s' },
      { target: (${var.config.rate} * 0.4), duration: '15s' },
      { target: (${var.config.rate} * 0.6), duration: '15s' },
      { target: (${var.config.rate} * 0.8), duration: '15s' },
      { target: ${var.config.rate}, duration: (${var.config.duration} - 1) + "m" },
    ]
  },
};

const { SCENARIO } = __ENV;
export const options = {
  discardResponseBodies: true,
  scenarios: { [SCENARIO]: scenarios[SCENARIO] },
};

export default function () {
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
    - name: K6_PROMETHEUS_RW_TREND_AS_NATIVE_HISTOGRAM
      value: "true"
  script:
    configMap:
      name: httpbin-${var.name}-configmap
      file: httpbin.js
YAML

  depends_on = [kubernetes_config_map.httpbin-configmap]
}