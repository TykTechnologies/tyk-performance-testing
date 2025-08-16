resource "helm_release" "tyk-operator" {
  count = var.use_config_maps_for_apis ? 0 : 1
  
  name       = "tyk-operator"
  repository = "https://helm.tyk.io/public/helm/charts/"
  chart      = "tyk-operator"

  namespace = var.namespace
  atomic    = true

  set {
    name  = "nodeSelector.node"
    value = var.resources-label
  }

  depends_on = [kubernetes_namespace.tyk, helm_release.tyk]
}