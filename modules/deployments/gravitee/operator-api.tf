resource "kubectl_manifest" "timestamp-keyless" {
  yaml_body = <<YAML
apiVersion: gravitee.io/v1alpha1
kind: ApiDefinition
metadata:
  name: "timestamp"
  namespace: "${var.namespace}"
  annotations:
    pt-annotations-auth: "${var.auth.enabled}"
    pt-annotations-rate-limiting: "${var.rate_limit.enabled}"
    pt-annotations-quota: "${var.quota.enabled}"
    pt-annotations-open-telemetry: "${var.open_telemetry.enabled}"
    pt-annotations-analytics-database: "${var.analytics.database.enabled}"
    pt-annotations-analytics-prometheus: "${var.analytics.prometheus.enabled}"
spec:
  name: "timestamp"
  contextRef:
    name: "gravitee-context"
    namespace: "${var.namespace}"
  version: "1.0"
  description: "timestamp-keyless"
  plans:
  - name: "KEY_LESS"
    description: "KEY_LESS"
    security: "KEY_LESS"
  proxy:
    virtual_hosts:
    - path: /timestamp
    groups:
    - endpoints:
      - name: "Default"
        target: "http://timestamp.gravitee-upstream.svc:3100"
YAML
  depends_on = [helm_release.gravitee-operator, kubectl_manifest.gravitee-context]
  count      = ! (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? 1 : 0
}

resource "kubectl_manifest" "timestamp" {
  yaml_body = <<YAML
apiVersion: gravitee.io/v1alpha1
kind: ApiDefinition
metadata:
  name: "timestamp"
  namespace: "${var.namespace}"
  annotations:
    pt-annotations-auth: "${var.auth.enabled}"
    pt-annotations-rate-limiting: "${var.rate_limit.enabled}"
    pt-annotations-quota: "${var.quota.enabled}"
    pt-annotations-open-telemetry: "${var.open_telemetry.enabled}"
    pt-annotations-analytics-database: "${var.analytics.database.enabled}"
    pt-annotations-analytics-prometheus: "${var.analytics.prometheus.enabled}"
spec:
  name: "timestamp"
  contextRef:
    name: "gravitee-context"
    namespace: "${var.namespace}"
  version: "1.0"
  description: "timestamp"
  visibility: "PUBLIC"
  lifecycle_state: "PUBLISHED"
  plans:
  - name: "API_KEY"
    description: "API_KEY"
    security: "API_KEY"
    flows:
    - path-operator:
        path: "/"
        operator: "STARTS_WITH"
      pre:
      - name: "Rate limit"
        enabled: ${var.rate_limit.enabled}
        policy: "rate-limit"
        configuration:
          addHeaders: false
          async: false
          rate:
            periodTime: ${var.rate_limit.per}
            limit: ${var.rate_limit.rate}
            periodTimeUnit: "SECONDS"
      - name: "Quota"
        enabled: ${var.quota.enabled}
        policy: "quota"
        configuration:
          addHeaders: true
          async: false
          quota:
            periodTime: ${floor(var.quota.per / 3600)}
            limit: ${var.quota.rate}
            periodTimeUnit: "HOURS"
  proxy:
    virtual_hosts:
    - path: "/timestamp"
    groups:
    - endpoints:
      - name: "Default"
        target: "http://timestamp.gravitee-upstream.svc:3100"
YAML
  depends_on = [helm_release.gravitee-operator, kubectl_manifest.gravitee-context]
  count      = (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? 1 : 0
}
