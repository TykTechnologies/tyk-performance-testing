resource "kubectl_manifest" "timestamp-keyless" {
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: ApiDefinition
metadata:
  name: timestamp-keyless
  namespace: ${var.namespace}
spec:
  name: timestamp-keyless
  use_keyless: true
  protocol: http
  active: true
  proxy:
    target_url: http://timestamp.upstream.svc:3100
    listen_path: /timestamp-keyless
    strip_listen_path: true
YAML

  depends_on = [helm_release.tyk-operator]
}
