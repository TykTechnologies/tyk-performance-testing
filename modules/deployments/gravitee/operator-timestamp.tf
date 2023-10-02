resource "kubectl_manifest" "timestamp-keyless" {
  yaml_body = <<YAML
apiVersion: gravitee.io/v1alpha1
kind: ApiDefinition
metadata:
  name: timestamp-keyless
  namespace: ${var.namespace}
spec:
  name: timestamp-keyless
  plans:
    - name: "KEY_LESS"
      description: "FREE"
      security: "KEY_LESS"
  proxy:
    virtual_hosts:
    - path: /timestamp-keyless
    groups:
    - endpoints:
      - name: "Default"
        target: "http://timestamp.upstream.svc:3100"
YAML
  depends_on = [helm_release.gravitee-operator]
}
