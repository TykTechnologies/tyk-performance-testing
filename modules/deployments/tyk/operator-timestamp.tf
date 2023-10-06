resource "kubectl_manifest" "timestamp" {
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: ApiDefinition
metadata:
  name: timestamp
  namespace: ${var.namespace}
spec:
  name: timestamp
  use_keyless: true
  protocol: http
  active: true
  disable_quota: true
  disable_rate_limit: true
  proxy:
    target_url: http://timestamp.tyk-upstream.svc:3100
    listen_path: /timestamp
    strip_listen_path: true
YAML

  depends_on = [helm_release.tyk-operator]
}
