locals {
  plugin_list = compact([
      var.auth.enabled || var.quota.enabled || var.rate_limit.enabled ? "auth" : "",
      var.rate_limit.enabled ? "rate-limiting" : "",
      var.quota.enabled ? "quota" : "",
      var.analytics.prometheus.enabled ? "prometheus" : "",
      var.open_telemetry.enabled ? "otel" : "",
  ])
  p = join(",", local.plugin_list)
  plugins = length(local.plugin_list) == 0 ? "" : (local.p == null ? "" : local.p)
}

resource "kubectl_manifest" "rate-limit-plugin" {
  yaml_body = <<YAML
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: rate-limiting
  namespace: "${var.namespace}-upstream"
plugin: rate-limiting
config:
  second: ${var.rate_limit.per * var.rate_limit.rate}
  policy: redis
  redis_host: "${helm_release.kong-redis.name}-redis-master"
  redis_password: ${local.redis-pass}
YAML
  depends_on = [helm_release.kong]
}

resource "kubectl_manifest" "quota-plugin" {
  yaml_body = <<YAML
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: quota
  namespace: "${var.namespace}-upstream"
plugin: rate-limiting
config:
  second: ${var.quota.per * var.quota.rate}
  policy: redis
  redis_host: "${helm_release.kong-redis.name}-redis-master"
  redis_password: ${local.redis-pass}
YAML
  depends_on = [helm_release.kong]
}

resource "kubectl_manifest" "auth-plugin" {
  yaml_body = <<YAML
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: auth
  namespace: "${var.namespace}-upstream"
plugin: key-auth
config:
   key_names:
   - Authorization
YAML
  depends_on = [helm_release.kong]
}

resource "kubectl_manifest" "prometheus-plugin" {
  yaml_body = <<YAML
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: prometheus
  namespace: "${var.namespace}-upstream"
plugin: prometheus
config:
  per_consumer: true
YAML
  depends_on = [helm_release.kong]
}

resource "kubectl_manifest" "otel-plugin" {
  yaml_body = <<YAML
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: otel
  namespace: "${var.namespace}-upstream"
plugin: prometheus
config:
  endpoint: http://opentelemetry-collector.dependencies.svc:4317/v1/traces
  resource_attributes:
    service.name: kong
YAML
  depends_on = [helm_release.kong]
}