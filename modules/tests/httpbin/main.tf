terraform {
  required_providers {
    kubectl = {
      source = "alekc/kubectl"
      version = ">= 2.0.2"
    }
  }
}

resource "random_string" "httpbin-keyless-test-suffix" {
  length  = 10
  special = false
  upper   = true
}

resource "kubernetes_config_map" "httpbin-keyless-configmap" {
  metadata {
    name      = "httpbin-${var.service_name}-configmap"
    namespace = var.namespace
  }

  data = {
    "httpbin.js" = <<EOF
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
    http.get('http://${var.service_url}/httpbin-keyless/status/' + status);
}

export function success() {
    sendStatus(200);
}
EOF
  }
}

resource "kubectl_manifest" "httpbin-keyless" {
  yaml_body = <<YAML
apiVersion: k6.io/v1alpha1
kind: K6
metadata:
  name: httpbin
  namespace: ${var.namespace}
spec:
  parallelism: ${var.parallelism}
  separate: false
  quiet: "false"
  separate: true
  cleanup: "post"
  arguments: --out experimental-prometheus-rw --tag testid=${var.service_name}-httpbin-keyless-${random_string.httpbin-keyless-test-suffix.result}
  initializer:
    nodeselector:
      node: k6
  starter:
    nodeselector:
      node: k6
  runner:
    nodeselector:
      node: k6
    env:
    - name: K6_PROMETHEUS_RW_SERVER_URL
      value: http://prometheus-server.dependencies.svc:80/api/v1/write
    - name: K6_PROMETHEUS_RW_PUSH_INTERVAL
      value: 1s
    - name: K6_PROMETHEUS_RW_TREND_AS_NATIVE_HISTOGRAM
      value: "true"
  script:
    configMap:
      name: httpbin-${var.service_name}-configmap
      file: httpbin.js
YAML

  depends_on = [kubernetes_config_map.httpbin-keyless-configmap]
}
