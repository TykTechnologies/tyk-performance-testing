resource "helm_release" "k6-operator" {
  name       = "k6-operator"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "k6-operator"
  version    = "1.2.0"

  namespace = var.namespace
  atomic    = true
  timeout   = 600  # 10 minutes

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

  depends_on = [kubernetes_namespace.dependencies]
}
