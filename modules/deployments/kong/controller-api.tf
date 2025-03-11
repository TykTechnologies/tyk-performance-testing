resource "kubectl_manifest" "api" {
  yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-${count.index}
  namespace: "${var.namespace}-upstream"
  annotations:
    konghq.com/strip-path: 'true'
    konghq.com/plugins: "${local.plugins}"
    pt-annotations-auth: "${var.auth.enabled}"
    pt-annotations-rate-limiting: "${var.rate_limit.enabled}"
    pt-annotations-quota: "${var.quota.enabled}"
    pt-annotations-open-telemetry: "${var.open_telemetry.enabled}"
    pt-annotations-analytics-database: "${var.analytics.database.enabled}"
    pt-annotations-analytics-prometheus: "${var.analytics.prometheus.enabled}"
    pt-annotations-req-header-injection: "${var.header_injection.req.enabled}"
    pt-annotations-res-header-injection: "${var.header_injection.res.enabled}"
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - path: /api-${count.index}
        pathType: ImplementationSpecific
        backend:
          service:
            name: fortio-${count.index % var.service.host_count}
            port:
              number: 8080
YAML
  count      = var.service.route_count
  depends_on = [helm_release.kong]
}
