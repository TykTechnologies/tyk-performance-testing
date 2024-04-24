terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.4"
    }
  }
}

resource "kubernetes_config_map" "timestamp-configmap" {
  metadata {
    name      = "timestamp-${var.name}-configmap"
    namespace = var.name
  }

  data = {
    "timestamp.js" = <<EOF
import http from 'k6/http';

export const options = {
  discardResponseBodies: true,
  scenarios: {
    success: {
      executor: 'constant-vus',
      exec: 'get',
      vus: 50,
      duration: '15m',
    }
  }
};

export function get() {
  http.get('http://${var.url}/timestamp/json');
}
EOF
  }
}

resource "kubectl_manifest" "timestamp" {
  yaml_body = <<YAML
apiVersion: k6.io/v1alpha1
kind: K6
metadata:
  name: timestamp
  namespace: ${var.name}
spec:
  parallelism: ${var.parallelism}
  separate: false
  quiet: "false"
  cleanup: "post"
  arguments: --out experimental-prometheus-rw --tag testid=${var.name}-timestamp
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
      name: timestamp-${var.name}-configmap
      file: timestamp.js
YAML

  depends_on = [kubernetes_config_map.timestamp-configmap]
}