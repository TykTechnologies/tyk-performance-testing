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
import { getScenarios, get } from "/helpers/tests.js";

const { SCENARIO } = __ENV;
export const options = {
  discardResponseBodies: true,
  scenarios: { [SCENARIO]: scenarios[SCENARIO] },
};

export default function () {
  get({
    duration: ${var.config.duration},
    rate: ${var.config.rate},
    virtual_users: ${var.config.virtual_users},
  }, 'http://${var.url}/httpbin/status/200');
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
    volumes:
    - name: tests
      configMap:
        name: tests-configmap
    volumeMounts:
    - name: tests
      mountPath: /helpers/tests.js
      subPath: tests.js
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
    volumes:
    - name: tests
      configMap:
        name: tests-configmap
    volumeMounts:
    - name: tests
      mountPath: /helpers/tests.js
      subPath: tests.js
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