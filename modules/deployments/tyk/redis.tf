resource "helm_release" "tyk-redis" {
  name       = "tyk-redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = "17.4.0"

  # Adjust default value to 10 minutes allow for all Redis containers to come up
  timeout = 600

  namespace        = var.namespace
  create_namespace = true
  atomic           = true

  set {
    name  = "image.tag"
    value = "6.2.7"
  }

  set {
    name  = "auth.password"
    value = local.redis-pass
  }

  set {
    name  = "volumePermissions.enabled"
    value = true
  }

  set {
    name  = "master.service.ports.redis"
    value = local.redis-port
  }

  set {
    name  = "master.nodeSelector.node"
    value = var.resources-label
  }

  set {
    name  = "replica.service.ports.redis"
    value = local.redis-port
  }

  set {
    name  = "replica.replicaCount"
    value = 1
  }

  set {
    name  = "replica.nodeSelector.node"
    value = var.resources-label
  }
}