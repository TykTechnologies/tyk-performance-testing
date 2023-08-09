resource "helm_release" "promethus" {
  name       = "promethus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "23.3.0"

  namespace        = "dependencies"
  create_namespace = true

  set {
    name  = "server.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "server.extraFlags[0]"
    value = "web.enable-remote-write-receiver"
  }
}