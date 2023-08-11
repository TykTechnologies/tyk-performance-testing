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

  depends_on = [kubernetes_namespace.dependencies]
}