resource "helm_release" "tyk-pgsql" {
  name       = "tyk-pgsql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "11.9.7"

  namespace = var.namespace
  atomic    = false  # Disabled: keep resources on timeout to allow debugging
  timeout   = 1800  # 30 minutes - bitnamilegacy pulls + 20GB volume provisioning can be slow

  set {
    name  = "auth.database"
    value = local.pgsql-name
  }

  set {
    name  = "auth.postgresPassword"
    value = local.pgsql-pass
  }

  set {
    name  = "auth.username"
    value = local.pgsql-user
  }

  set {
    name  = "auth.password"
    value = local.pgsql-pass
  }

  set {
    name  = "containerPorts.postgresql"
    value = local.pgsql-port
  }

  set {
    name  = "primary.service.ports.postgresql"
    value = local.pgsql-port
  }

  set {
    name  = "primary.resources"
    value = "null"
  }

  set {
    name  = "primary.persistence.size"
    value = "20Gi"
  }

  set {
    name  = "primary.nodeSelector.node"
    value = var.resources-label
  }

  set {
    name  = "readReplicas.nodeSelector.node"
    value = var.resources-label
  }

  # Bitnami deprecated free images on Aug 28, 2025 - use legacy repository
  set {
    name  = "image.repository"
    value = "bitnamilegacy/postgresql"
  }

  # Use Docker Hub credentials to bypass rate limits
  set {
    name  = "image.pullSecrets[0]"
    value = "dockerhub-secret"
  }

  depends_on = [kubernetes_namespace.tyk, kubernetes_namespace.tyk]
}
