terraform {
  required_providers {
    kubectl = {
      source = "alekc/kubectl"
      version = ">= 2.0.2"
    }
  }
}

resource "kubernetes_config_map" "httpbin-configmap" {
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
  script:
    configMap:
      name: httpbin-${var.service_name}-configmap
      file: httpbin.js
YAML

  depends_on = [kubernetes_config_map.httpbin-configmap]
}

