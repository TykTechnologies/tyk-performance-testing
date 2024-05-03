resource "kubectl_manifest" "httpbin" {
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: ApiDefinition
metadata:
  name: httpbin
  namespace: ${var.namespace}
spec:
  name: httpbin
  protocol: http
  active: true
  disable_quota: ${! var.quota.enabled}
  disable_rate_limit: ${! var.rate_limit.enabled}
  proxy:
    target_url: http://httpbin.tyk-upstream.svc:8000
    listen_path: /httpbin
    strip_listen_path: true
  use_keyless: ${! var.auth.enabled}
  use_standard_auth: ${var.auth.enabled}
  auth_configs:
    authToken:
      auth_header_name: Authorization
YAML

  depends_on = [helm_release.tyk-operator]
}

resource "kubectl_manifest" "httpbin-policy" {
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: httpbin-policy
  namespace: ${var.namespace}
spec:
  name: httpbin-policy
  state: active
  active: true
  access_rights_array:
    - name: httpbin
      namespace: ${var.namespace}
      versions:
        - Default
YAML

  depends_on = [kubectl_manifest.httpbin]
  count      = var.auth.enabled ? 1 : 0
}
