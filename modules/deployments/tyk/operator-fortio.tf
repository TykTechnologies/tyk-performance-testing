resource "kubectl_manifest" "fortio" {
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: ApiDefinition
metadata:
  name: fortio
  namespace: ${var.namespace}
spec:
  name: fortio
  protocol: http
  active: true
  disable_quota: ${! var.quota.enabled}
  disable_rate_limit: ${! var.rate_limit.enabled}
  proxy:
    target_url: http://fortio-server.tyk-upstream.svc:8080
    listen_path: /fortio
    strip_listen_path: true
  use_keyless: ${! (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled)}
  use_standard_auth: ${var.auth.enabled || var.rate_limit.enabled || var.quota.enabled}
  auth_configs:
    authToken:
      auth_header_name: Authorization
YAML

  depends_on = [helm_release.tyk-operator]
}

resource "kubectl_manifest" "fortio-policy" {
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: fortio-policy
  namespace: ${var.namespace}
spec:
  name: fortio-policy
  state: active
  active: true
  quota_max: ${var.quota.enabled ? var.quota.rate : -1}
  quota_renewal_rate: ${var.quota.enabled ? var.quota.per : -1}
  rate: ${var.rate_limit.enabled ? var.rate_limit.rate : -1}
  per: ${var.rate_limit.enabled ? var.rate_limit.per : -1}
  throttle_interval: -1
  throttle_retry_limit: -1
  access_rights_array:
  - name: fortio
    namespace: ${var.namespace}
    versions:
    - Default
YAML

  depends_on = [kubectl_manifest.timestamp]
  count      = (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? 1 : 0
}
