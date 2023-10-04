resource "kubectl_manifest" "httpbin-keyless" {
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: ApiDefinition
metadata:
  name: httpbin-keyless
  namespace: ${var.namespace}
spec:
  name: httpbin-keyless
  use_keyless: true
  protocol: http
  active: true
  disable_quota: true
  disable_rate_limit: true
  proxy:
    target_url: http://httpbin.tyk-upstream.svc:8000
    listen_path: /httpbin-keyless
    strip_listen_path: true
YAML

  depends_on = [helm_release.tyk-operator]
}
