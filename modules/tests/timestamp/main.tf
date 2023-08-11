terraform {
  required_providers {
    kubectl = {
      source = "alekc/kubectl"
      version = ">= 2.0.2"
    }
  }
}

resource "random_string" "timestamp-keyless-test-suffix" {
  length  = 10
  special = false
  upper   = true
}


resource "kubernetes_config_map" "timestamp-keyless-configmap" {
  metadata {
    name      = "timestamp-${var.service_name}-configmap"
    namespace = var.namespace
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
    http.get('http://${var.service_url}/timestamp-keyless/json');
}
EOF
  }
}

resource "kubectl_manifest" "timestamp-keyless" {
  yaml_body = <<YAML
apiVersion: k6.io/v1alpha1
kind: K6
metadata:
  name: timestamp
  namespace: ${var.namespace}
spec:
  parallelism: ${var.parallelism}
  separate: false
  quiet: "false"
  separate: true
  cleanup: "post"
  arguments: --out experimental-prometheus-rw --tag testid=${var.service_name}-timestamp-keyless-${random_string.timestamp-keyless-test-suffix.result}
  runner:
    env:
    - name: K6_PROMETHEUS_RW_SERVER_URL
      value: http://prometheus-server.dependencies.svc:80/api/v1/write
    - name: K6_PROMETHEUS_RW_PUSH_INTERVAL
      value: 1s
    - name: K6_PROMETHEUS_RW_TREND_AS_NATIVE_HISTOGRAM
      value: "true"
  script:
    configMap:
      name: timestamp-${var.service_name}-configmap
      file: timestamp.js
YAML

  depends_on = [kubernetes_config_map.timestamp-keyless-configmap]
}
