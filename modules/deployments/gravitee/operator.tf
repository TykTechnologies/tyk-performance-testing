resource "helm_release" "gravitee-operator" {
  name       = "gravitee-operator"
  repository = "https://helm.gravitee.io"
  chart      = "gko"

  namespace        = var.namespace
  create_namespace = true
  atomic           = true

# Gravitee Operator does not support nodeSelectors
#  set {
#    name  = "nodeSelector.node"
#    value = var.resources-label
#  }

# Gravitee Operator does not support resource management and has hard coded values :(
#  set {
#    name  = "manager.resources"
#    value = null
#  }

  depends_on = [helm_release.gravitee]
}
