resource "helm_release" "pgsql" {
  name       = "pgsql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "11.9.7"

  namespace        = var.namespace
  create_namespace = true
  atomic           = true

  set {
    name  = "auth.database"
    value = local.database-name
  }

  set {
    name  = "auth.postgresPassword"
    value = local.database-pass
  }

  set {
    name  = "auth.username"
    value = local.database-user
  }

  set {
    name  = "auth.password"
    value = local.database-pass
  }

  set {
    name  = "containerPorts.postgresql"
    value = local.database-port
  }

  set {
    name  = "primary.service.ports.postgresql"
    value = local.database-port
  }

  set {
    name  = "primary.nodeSelector.node"
    value = var.resources-label
  }

  set {
    name  = "readReplicas.nodeSelector.node"
    value = var.resources-label
  }
}

