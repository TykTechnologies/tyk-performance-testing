resource "helm_release" "tyk-redis" {
  name       = "tyk-redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis-cluster"
  version    = "10.2.0"

  # Increased to 30 minutes - bitnamilegacy pulls can be slow due to Docker Hub rate limits
  # Redis cluster needs 6 pods to form, each pulling images + volume provisioning
  timeout = 1800

  namespace = var.namespace
  atomic    = false  # Disabled: keep resources on timeout to allow debugging
  wait       = true   # Wait for deployment to complete

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