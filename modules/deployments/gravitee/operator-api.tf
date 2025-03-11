resource "kubectl_manifest" "api-keyless" {
  yaml_body = <<YAML
apiVersion: gravitee.io/v1alpha1
kind: ApiDefinition
metadata:
  name: "api-${count.index}"
  namespace: "${var.namespace}"
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
  name: "api-${count.index}"
  contextRef:
    name: "gravitee-context"
    namespace: "${var.namespace}"
  version: "1.0"
  description: "api-${count.index}-keyless"
  plans:
  - name: "KEY_LESS"
    description: "KEY_LESS"
    security: "KEY_LESS"
  proxy:
    virtual_hosts:
    - path: /api-${count.index}
    groups:
    - endpoints:
      - name: "Default"
        target: "http://fortio-${count.index % var.service.host_count}.gravitee-upstream.svc:8080"
YAML
  count      = ! (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? var.service.route_count : 0
  depends_on = [helm_release.gravitee-operator, kubectl_manifest.gravitee-context]
}

resource "kubectl_manifest" "api" {
  yaml_body = <<YAML
apiVersion: gravitee.io/v1alpha1
kind: ApiDefinition
metadata:
  name: "api-${count.index}"
  namespace: "${var.namespace}"
  annotations:
    pt-annotations-auth: "${var.auth.enabled}"
    pt-annotations-rate-limiting: "${var.rate_limit.enabled}"
    pt-annotations-quota: "${var.quota.enabled}"
    pt-annotations-open-telemetry: "${var.open_telemetry.enabled}"
    pt-annotations-analytics-database: "${var.analytics.database.enabled}"
    pt-annotations-analytics-prometheus: "${var.analytics.prometheus.enabled}"
spec:
  name: "api-${count.index}"
  contextRef:
    name: "gravitee-context"
    namespace: "${var.namespace}"
  version: "1.0"
  description: "api-${count.index}"
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
    - path: "/api-${count.index}"
    groups:
    - endpoints:
      - name: "Default"
        target: "http://fortio-${count.index % var.service.host_count}.gravitee-upstream.svc:8080"
YAML
  count      = (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? var.service.route_count : 0
  depends_on = [helm_release.gravitee, helm_release.gravitee-operator, kubectl_manifest.gravitee-context]
}
