resource "kubectl_manifest" "gravitee-context" {
  yaml_body = <<YAML
apiVersion: gravitee.io/v1alpha1
kind: ManagementContext
metadata:
  name: "gravitee-context"
  namespace: "${var.namespace}"
spec:
  baseUrl: "http://${helm_release.gravitee.name}-apim-api.${var.namespace}.svc:83"
  environmentId: "DEFAULT"
  organizationId: "DEFAULT"
  auth:
    credentials:
      username: "admin"
      password: "admin"
YAML
  depends_on = [helm_release.gravitee, helm_release.gravitee-operator]
}