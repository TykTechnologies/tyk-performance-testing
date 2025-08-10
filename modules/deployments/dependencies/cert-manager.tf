resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.10.1"

  namespace = var.namespace
  atomic    = true
  timeout   = 1800  # 30 minutes for AWS EKS compatibility

  set {
    name  = "installCRDs"
    value = true
  }

  set {
    name  = "nodeSelector.node"
    value = var.label
  }

  set {
    name  = "webhook.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "cainjector.nodeSelector.node"
    value = var.label
  }

  # Reduce resource requirements for better AWS EKS compatibility
  set {
    name  = "resources.requests.cpu"
    value = "50m"
  }

  set {
    name  = "resources.requests.memory"
    value = "64Mi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "resources.limits.memory"
    value = "128Mi"
  }

  set {
    name  = "webhook.resources.requests.cpu"
    value = "25m"
  }

  set {
    name  = "webhook.resources.requests.memory"
    value = "32Mi"
  }

  set {
    name  = "webhook.resources.limits.cpu"
    value = "100m"
  }

  set {
    name  = "webhook.resources.limits.memory"
    value = "64Mi"
  }

  set {
    name  = "cainjector.resources.requests.cpu"
    value = "25m"
  }

  set {
    name  = "cainjector.resources.requests.memory"
    value = "32Mi"
  }

  set {
    name  = "cainjector.resources.limits.cpu"
    value = "100m"
  }

  set {
    name  = "cainjector.resources.limits.memory"
    value = "64Mi"
  }

  depends_on = [kubernetes_namespace.dependencies]
}