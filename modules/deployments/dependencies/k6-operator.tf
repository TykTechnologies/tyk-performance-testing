resource "helm_release" "k6-operator" {
  name       = "k6-operator"
  chart      = "../modules/deployments/dependencies/k6-operator/charts"

  namespace        = var.namespace
  create_namespace = true
  atomic           = true

  set {
    name  = "authProxy.enabled"
    value = "false"
  }

  set {
    name  = "manager.resources"
    value = "null"
  }

  set {
    name  = "nodeSelector.node"
    value = var.label
  }
}
