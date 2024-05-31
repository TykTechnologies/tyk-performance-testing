resource "helm_release" "kong-pgsql" {
  name       = "kong-pgsql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "11.9.7"

  namespace = var.namespace
  atomic    = true

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
    name  = "primary.nodeSelector.node"
    value = var.resources-label
  }

  set {
    name  = "readReplicas.nodeSelector.node"
    value = var.resources-label
  }

  depends_on = [kubernetes_namespace.kong]
}

