resource "helm_release" "tyk-redis" {
  name       = "tyk-redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis-cluster"
  version    = "10.2.0"

  # Adjust default value to 10 minutes allow for all Redis containers to come up
  timeout = 600

  namespace = var.namespace
  atomic    = true

  set {
    name  = "password"
    value = local.redis-pass
  }

  set {
    name  = "volumePermissions.enabled"
    value = true
  }

  set {
    name  = "service.ports.redis"
    value = local.redis-port
  }

  set {
    name  = "redis.nodeSelector.node"
    value = var.resources-label
  }

  set {
    name  = "redis.resourcesPreset"
    value = "none"
  }

  depends_on = [kubernetes_namespace.tyk, kubernetes_namespace.tyk]
}