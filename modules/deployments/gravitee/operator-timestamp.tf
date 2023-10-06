resource "kubectl_manifest" "timestamp" {
  yaml_body = <<YAML
apiVersion: gravitee.io/v1alpha1
kind: ApiDefinition
metadata:
  name: timestamp
  namespace: ${var.namespace}
spec:
  name: timestamp
  plans:
    - name: "KEY_LESS"
      description: "FREE"
      security: "KEY_LESS"
  proxy:
    virtual_hosts:
    - path: /timestamp
    groups:
    - endpoints:
      - name: "Default"
        target: "http://timestamp.gravitee-upstream.svc:3100"
YAML
  depends_on = [helm_release.gravitee-operator]
}
