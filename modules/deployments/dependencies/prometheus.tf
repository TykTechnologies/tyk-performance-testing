resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "23.3.0"

  namespace = "dependencies"

  set {
    name  = "server.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "server.extraFlags[0]"
    value = "web.enable-remote-write-receiver"
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

  depends_on = [kubernetes_namespace.dependencies]
}