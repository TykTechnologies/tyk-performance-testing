resource "helm_release" "tyk-operator" {
  name       = "tyk-operator"
  repository = "https://helm.tyk.io/public/helm/charts/"
  chart      = "tyk-operator"

  namespace        = var.namespace
  create_namespace = true
  atomic           = true

  set {
    name  = "nodeSelector.node"
    value = var.resources-label
  }

  depends_on = [helm_release.tyk]
}