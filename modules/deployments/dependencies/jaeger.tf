resource "helm_release" "jaeger" {
  name       = "jaeger"
  repository = "https://jaegertracing.github.io/helm-charts"
  chart      = "jaeger"
  version    = "0.71.11"

  namespace = var.namespace
  atomic    = true

  set {
    name  = "provisionDataStore.cassandra"
    value = false
  }

  set {
    name  = "provisionDataStore.elasticsearch"
    value = true
  }

  set {
    name  = "storage.type"
    value = "elasticsearch"
  }

  set {
    name  = "elasticsearch.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "elasticsearch.antiAffinity"
    value = "soft"
  }

  set {
    name  = "agent.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "collector.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "query.nodeSelector.node"
    value = var.label
  }

  depends_on = [helm_release.cert-manager]

  count = var.open_telemetry.enabled ? 1 : 0
}
