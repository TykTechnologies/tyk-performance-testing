resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "23.3.0"

  namespace = var.namespace
  atomic    = true

  set {
    name  = "server.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "server.extraFlags[0]"
    value = "web.enable-remote-write-receiver"
  }

  # Keep recently-finished k6 series queryable at the right edge of the
  # dashboard so snapshots taken just after a test still graph RPS/latency.
  set {
    name  = "server.extraFlags[1]"
    value = "query.lookback-delta=15m"
  }

  set {
    name  = "server.extraArgs.enable-feature"
    value = "native-histograms"
  }

  set {
    name  = "alertmanager.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "kube-state-metrics.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "prometheus-pushgateway.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "kube-state-metrics.extraArgs[0]"
    value = "--metric-labels-allowlist=nodes=[*]"
  }

  depends_on = [kubernetes_namespace.dependencies]
}