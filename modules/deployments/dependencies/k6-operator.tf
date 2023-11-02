resource "helm_release" "k6-operator" {
  name       = "k6-operator"
#  chart      = "../modules/deployments/dependencies/k6-operator/charts"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "k6-operator"
  version    = "1.2.0"

  namespace        = var.namespace
  create_namespace = true
  atomic           = true

  set {
    name  = "namespace.create"
    value = "false"
  }

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
