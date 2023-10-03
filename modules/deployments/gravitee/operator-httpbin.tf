resource "kubectl_manifest" "httpbin-keyless" {
  yaml_body = <<YAML
apiVersion: gravitee.io/v1alpha1
kind: ApiDefinition
metadata:
  name: httpbin-keyless
  namespace: ${var.namespace}
spec:
  name: httpbin-keyless
  plans:
    - name: "KEY_LESS"
      description: "FREE"
      security: "KEY_LESS"
  proxy:
    virtual_hosts:
    - path: /httpbin-keyless
    groups:
    - endpoints:
      - name: "Default"
        target: "http://httpbin.gravitee-upstream.svc:8000"
YAML
  depends_on = [helm_release.gravitee-operator]
}
