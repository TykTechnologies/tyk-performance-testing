resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.10.1"

  namespace = var.namespace
  atomic    = true
  timeout   = 600  # 10 minutes instead of default 5 minutes

  set {
    name  = "installCRDs"
    value = true
  }

  set {
    name  = "nodeSelector.node"
    value = var.label
  }

  set {
    name  = "webhook.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "cainjector.nodeSelector.node"
    value = var.label
  }

  depends_on = [kubernetes_namespace.dependencies]
}