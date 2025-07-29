resource "helm_release" "gravitee-operator" {
  name       = "gravitee-operator"
  repository = "https://helm.gravitee.io"
  chart      = "gko"

  namespace = var.namespace
  atomic    = true

  # Gravitee Operator does not support nodeSelectors
  #  set {
  #    name  = "nodeSelector.node"
  #    value = var.resources-label
  #  }

  set {
    name  = "manager.resources.limits.cpu"
    value = "0"
  }

  set {
    name  = "manager.resources.limits.memory"
    value = "0"
  }

  set {
    name  = "manager.resources.requests.cpu"
    value = "0"
  }

  set {
    name  = "manager.resources.requests.memory"
    value = "0"
  }

  depends_on = [helm_release.gravitee]
}
