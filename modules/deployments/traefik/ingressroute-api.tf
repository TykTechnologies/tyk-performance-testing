resource "kubectl_manifest" "api" {
  yaml_body = <<YAML
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: api-${count.index}
  namespace: "${var.namespace}-upstream"
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
  entryPoints:
  - web
  routes:
  - kind: Rule
    match: PathPrefix(`/api-${count.index}`)
    services:
    - name: fortio-${count.index % var.service.host_count}
      port: 8080
YAML
  count      = var.service.route_count
  depends_on = [helm_release.traefik]
}
