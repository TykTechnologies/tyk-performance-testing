resource "helm_release" "tyk-operator" {
  name       = "tyk-operator"
  repository = "https://helm.tyk.io/public/helm/charts/"
  chart      = "tyk-operator"

  namespace = var.namespace
  atomic    = true

  set = {
    name  = "nodeSelector.node"
    value = var.resources-label
  }

  depends_on = [kubernetes_namespace.tyk, helm_release.tyk]
}