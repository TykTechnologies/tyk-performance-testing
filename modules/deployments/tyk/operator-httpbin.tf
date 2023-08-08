terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

resource "kubectl_manifest" "httpbin-keyless" {
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: ApiDefinition
metadata:
  name: httpbin-keyless
  namespace: tyk
spec:
  name: httpbin-keyless
  use_keyless: true
  protocol: http
  active: true
  proxy:
    target_url: http://httpbin.upstream.svc:8080
    listen_path: /httpbin-keyless
    strip_listen_path: true
YAML
}
