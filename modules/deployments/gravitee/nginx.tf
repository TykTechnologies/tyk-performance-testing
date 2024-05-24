resource "helm_release" "gravitee-nginx" {
  name       = "gravitee-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.1"

  namespace        = var.namespace
  create_namespace = true
  atomic           = true

  set {
    name  = "controller.nodeSelector.node"
    value = var.resources-label
  }

  set {
    name  = "controller.resources.requests.cpu"
    value = "0"
  }

  set {
    name  = "controller.resources.requests.memory"
    value = "0"
  }
}
