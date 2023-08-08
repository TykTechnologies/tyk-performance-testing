terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

resource "kubernetes_config_map" "timestamp-configmap" {
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
    http.get('http://${var.service_url}/timestamp/json');
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
  quiet: false
  script:
    name: timestamp-${var.service_name}-configmap
    file: timestamp.js
YAML

  depends_on = [kubernetes_config_map.timestamp-configmap]
}
