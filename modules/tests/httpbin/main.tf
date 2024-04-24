terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.4"
    }
  }
}

resource "kubectl_manifest" "httpbin-configmap" {
  yaml_body = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: "httpbin-${var.name}-configmap"
  namespace: ${var.name}
data:
  httpbin.js: |
    import http from 'k6/http';

    export const options = {
      discardResponseBodies: true,
      scenarios: {
        success: {
          executor: 'constant-vus',
          exec: 'success',
          vus: 50,
          duration: '15m',
        }
      }
    };

    function sendStatus(status) {
      http.get('http://${var.url}/httpbin/status/' + status);
    }

    export function success() {
      sendStatus(200);
    }
YAML
}

resource "kubectl_manifest" "httpbin" {
  yaml_body = <<YAML
apiVersion: k6.io/v1alpha1
kind: K6
metadata:
  name: httpbin
  namespace: ${var.name}
spec:
  parallelism: ${var.parallelism}
  separate: false
  quiet: "false"
  cleanup: "post"
  arguments: --out experimental-prometheus-rw --tag testid=${var.name}-httpbin
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

  depends_on = [kubectl_manifest.httpbin-configmap]
}
