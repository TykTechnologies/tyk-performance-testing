resource "kubernetes_namespace" "k6" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "k6-operator" {
  name       = "k6-operator"
  chart      = "../modules/deployments/k6/k6-operator/charts"

  namespace = var.namespace
  atomic    = true

  set {
    name  = "authProxy.enabled"
    value = "false"
  }

  set {
    name  = "nodeSelector.node"
    value = var.label
  }

  depends_on = [kubernetes_namespace.k6]
}
