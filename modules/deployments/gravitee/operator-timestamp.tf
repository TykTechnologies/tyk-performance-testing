resource "kubectl_manifest" "timestamp-keyless" {
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
  depends_on = [helm_release.gravitee-operator]
  count      = ! (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? 1 : 0
}

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
    description: "KEY_LESS"
    security: "KEY_LESS"
    flows:
    - name: "traffic"
      path-operator:
        path: "/"
        operator: "STARTS_WITH"
      pre:
      - name: "rate-limit"
        enabled: ${var.rate_limit.enabled}
        policy: "rate-limit"
        configuration:
          rate:
            periodTime: ${var.rate_limit.per}
            limit: ${var.rate_limit.rate}
            periodTimeUnit: "SECONDS"
      - name: "quota"
        enabled: ${var.quota.enabled}
        policy: "quota"
        configuration:
          quota:
            periodTime: ${var.quota.per}
            limit: ${var.quota.rate}
            periodTimeUnit: "SECONDS"
  proxy:
    virtual_hosts:
    - path: /timestamp
    groups:
    - endpoints:
      - name: "Default"
        target: "http://timestamp.gravitee-upstream.svc:3100"
YAML
  depends_on = [helm_release.gravitee-operator]
  count      = (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? 1 : 0
}
