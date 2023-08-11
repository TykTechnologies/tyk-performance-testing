resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.10.1"

  namespace = "dependencies"

  set {
    name  = "installCRDs"
    value = true
  }

  set {
    name  = "nodeSelector.node"
    value = var.label
  }

  depends_on = [kubernetes_namespace.dependencies]
}