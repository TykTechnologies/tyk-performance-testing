resource "helm_release" "tyk-redis" {
  name       = "tyk-redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = "17.4.0"

  namespace = var.namespace
  atomic    = true

  set {
    name  = "image.tag"
    value = "6.2.7"
  }

  set {
    name  = "auth.password"
    value = "topsecretpassword"
  }

  set {
    name  = "volumePermissions.enabled"
    value = true
  }

  set {
    name  = "master.nodeSelector.node"
    value = var.resources-label
  }

  set {
    name  = "replica.nodeSelector.node"
    value = var.resources-label
  }

  depends_on = [kubernetes_namespace.tyk]
}