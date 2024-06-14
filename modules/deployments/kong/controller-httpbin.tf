resource "kubectl_manifest" "httpbin" {
  force_new = true
  yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: httpbin
  namespace: "${var.namespace}-upstream"
  annotations:
    konghq.com/strip-path: 'true'
    konghq.com/plugins: ${join(",", local.plugins)}
    pt-annotations-auth: "${var.auth.enabled}"
    pt-annotations-rate-limiting: "${var.rate_limit.enabled}"
    pt-annotations-quota: "${var.quota.enabled}"
    pt-annotations-open-telemetry: "${var.open_telemetry.enabled}"
    pt-annotations-analytics-database: "${var.analytics.database.enabled}"
    pt-annotations-analytics-prometheus: "${var.analytics.prometheus.enabled}"
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - path: /httpbin
        pathType: ImplementationSpecific
        backend:
          service:
            name: httpbin
            port:
              number: 8000
YAML
  depends_on = [helm_release.kong]
}
