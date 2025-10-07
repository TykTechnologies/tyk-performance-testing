resource "helm_release" "tyk-redis" {
  name       = "tyk-redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis-cluster"
  version    = "10.2.0"

  # Adjust default value to 20 minutes - Bitnami redis-cluster with volume permissions takes time
  timeout = 1200

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

  # Bitnami deprecated free images on Aug 28, 2025 - use legacy repository
  set {
    name  = "image.repository"
    value = "bitnamilegacy/redis-cluster"
  }

  depends_on = [kubernetes_namespace.tyk, kubernetes_namespace.tyk]
}