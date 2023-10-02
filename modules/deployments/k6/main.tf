resource "helm_release" "k6-operator" {
  name       = "k6-operator"
  chart      = "../modules/deployments/k6/k6-operator/charts"

  namespace        = var.namespace
  create_namespace = true
  atomic           = true

  set {
    name  = "authProxy.enabled"
    value = "false"
  }

  set {
    name  = "nodeSelector.node"
    value = var.label
  }
}
