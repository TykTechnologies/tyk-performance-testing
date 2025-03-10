resource "kubectl_manifest" "api" {
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: ApiDefinition
metadata:
  name: api
  namespace: ${var.namespace}
  annotations:
    pt-annotations-auth: "${var.auth.enabled}"
    pt-annotations-rate-limiting: "${var.rate_limit.enabled}"
    pt-annotations-quota: "${var.quota.enabled}"
    pt-annotations-open-telemetry: "${var.open_telemetry.enabled}"
    pt-annotations-analytics-database: "${var.analytics.database.enabled}"
    pt-annotations-analytics-prometheus: "${var.analytics.prometheus.enabled}"
    pt-annotations-req-header-injection: "${var.header_injection.req.enabled}"
    pt-annotations-res-header-injection: "${var.header_injection.res.enabled}"
spec:
  name: api
  protocol: http
  active: true
  disable_quota: ${! var.quota.enabled}
  disable_rate_limit: ${! var.rate_limit.enabled}
  proxy:
    target_url: http://fortio.tyk-upstream.svc:8080
    listen_path: /api
    strip_listen_path: true
  use_keyless: ${! (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled)}
  use_standard_auth: ${(var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) && var.auth.type == "authToken"}
  enable_jwt: ${(var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) && (var.auth.type == "JWT-RSA" || var.auth.type == "JWT-HMAC")}
  auth_configs:
    authToken:
      auth_header_name: Authorization
  jwt_signing_method: ${var.auth.type == "JWT-HMAC" ? "hmac" : "rsa"}
  jwt_source: ${var.auth.type == "JWT-HMAC" ? "dG9wc2VjcmV0cGFzc3dvcmQ=" : "http://keycloak-service.dependencies.svc:8080/realms/jwt/protocol/openid-connect/certs"}
  jwt_identity_base_field: sub
  jwt_policy_field_name: pol
  jwt_default_policies:
    - "${var.namespace}/api-policy"
  version_data:
    default_version: Default
    not_versioned: true
    versions:
      Default:
        name: Default
        use_extended_paths: true
        global_headers: ${jsonencode(var.header_injection.req.enabled ? { "X-API-REQ": "Foo" } : {})}
        global_response_headers: ${jsonencode(var.header_injection.req.enabled ? { "X-API-RES": "Bar" } : {})}
YAML

  depends_on = [helm_release.tyk, helm_release.tyk-operator]
}

resource "kubectl_manifest" "api-policy" {
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: api-policy
  namespace: ${var.namespace}
  annotations:
    pt-annotations-auth: "${var.auth.enabled}"
    pt-annotations-auth-type: "${var.auth.type}"
    pt-annotations-rate-limiting: "${var.rate_limit.enabled}"
    pt-annotations-quota: "${var.quota.enabled}"
    pt-annotations-open-telemetry: "${var.open_telemetry.enabled}"
    pt-annotations-analytics-database: "${var.analytics.database.enabled}"
    pt-annotations-analytics-prometheus: "${var.analytics.prometheus.enabled}"
spec:
  name: api-policy
  state: active
  active: true
  quota_max: ${var.quota.enabled ? var.quota.rate : -1}
  quota_renewal_rate: ${var.quota.enabled ? var.quota.per : -1}
  rate: ${var.rate_limit.enabled ? var.rate_limit.rate : -1}
  per: ${var.rate_limit.enabled ? var.rate_limit.per : -1}
  throttle_interval: -1
  throttle_retry_limit: -1
  access_rights_array:
  - name: api
    namespace: ${var.namespace}
    versions:
    - Default
YAML

  depends_on = [kubectl_manifest.api]
  count      = (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? 1 : 0
}
