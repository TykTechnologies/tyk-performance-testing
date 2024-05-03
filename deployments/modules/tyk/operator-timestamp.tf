resource "kubectl_manifest" "timestamp" {
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: ApiDefinition
metadata:
  name: timestamp
  namespace: ${var.namespace}
spec:
  name: timestamp
  protocol: http
  active: true
  disable_quota: ${! var.quota.enabled}
  disable_rate_limit: ${! var.rate_limit.enabled}
  proxy:
    target_url: http://timestamp.tyk-upstream.svc:3100
    listen_path: /timestamp
    strip_listen_path: true
  use_keyless: ${! var.auth.enabled}
  use_standard_auth: ${var.auth.enabled}
  auth_configs:
    authToken:
      auth_header_name: Authorization
YAML

  depends_on = [helm_release.tyk-operator]
}

resource "kubectl_manifest" "timestamp-policy" {
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: timestamp-policy
  namespace: ${var.namespace}
spec:
  name: timestamp-policy
  state: active
  active: true
  access_rights_array:
    - name: timestamp
      namespace: ${var.namespace}
      versions:
        - Default
YAML

  depends_on = [kubectl_manifest.timestamp]
  count      = var.auth.enabled ? 1 : 0
}
