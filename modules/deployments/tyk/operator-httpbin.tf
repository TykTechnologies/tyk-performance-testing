resource "kubectl_manifest" "httpbin" {
  force_new = true
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: ApiDefinition
metadata:
  name: httpbin
  namespace: ${var.namespace}
  annotations:
    pt-annotations-auth: "${var.auth.enabled}"
    pt-annotations-rate-limiting: "${var.rate_limit.enabled}"
    pt-annotations-quota: "${var.quota.enabled}"
    pt-annotations-open-telemetry: "${var.open_telemetry.enabled}"
    pt-annotations-analytics-database: "${var.analytics.database.enabled}"
    pt-annotations-analytics-prometheus: "${var.analytics.prometheus.enabled}"
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
  use_keyless: ${! (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled)}
  use_standard_auth: ${var.auth.enabled || var.rate_limit.enabled || var.quota.enabled}
  auth_configs:
    authToken:
      auth_header_name: Authorization
YAML

  depends_on = [helm_release.tyk-operator]
}

resource "kubectl_manifest" "httpbin-policy" {
  force_new = true
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: httpbin-policy
  namespace: ${var.namespace}
  annotations:
    pt-annotations-auth: "${var.auth.enabled}"
    pt-annotations-rate-limiting: "${var.rate_limit.enabled}"
    pt-annotations-quota: "${var.quota.enabled}"
    pt-annotations-open-telemetry: "${var.open_telemetry.enabled}"
    pt-annotations-analytics-database: "${var.analytics.database.enabled}"
    pt-annotations-analytics-prometheus: "${var.analytics.prometheus.enabled}"
spec:
  name: httpbin-policy
  state: active
  active: true
  quota_max: ${var.quota.enabled ? var.quota.rate : -1}
  quota_renewal_rate: ${var.quota.enabled ? var.quota.per : -1}
  rate: ${var.rate_limit.enabled ? var.rate_limit.rate : -1}
  per: ${var.rate_limit.enabled ? var.rate_limit.per : -1}
  throttle_interval: -1
  throttle_retry_limit: -1
  access_rights_array:
  - name: httpbin
    namespace: ${var.namespace}
    versions:
    - Default
YAML

  depends_on = [kubectl_manifest.httpbin]
  count      = (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? 1 : 0
}
