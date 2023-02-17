resource "helm_release" "kong-redis" {
  name       = "kong-redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = "17.4.0"

  namespace        = var.namespace
  create_namespace = true
  atomic           = true

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
    name  = "redis.nodeSelector.node"
    value = var.resources-label
  }
}
