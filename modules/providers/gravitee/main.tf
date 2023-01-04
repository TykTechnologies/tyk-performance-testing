locals {
  database-name = "gravitee-database"
  database-user = "gravitee"
  database-pass = "topsecretpassword"
  database-port = "5432"
}

resource "helm_release" "gravitee" {
  name       = "gravitee"
  repository = "https://helm.gravitee.io"
  chart      = "apim3"

  namespace = var.namespace
  atomic    = true

  set {
    name  = "jdbc.driver"
    value = "https://jdbc.postgresql.org/download/postgresql-42.2.23.jar"
  }

  set {
    name  = "jdbc.url"
    value = "jdbc:postgresql://pgsql-postgresql:${local.database-port}/${local.database-name}"
  }

  set {
    name  = "jdbc.username"
    value = local.database-user
  }

  set {
    name  = "jdbc.password"
    value = local.database-pass
  }

  set {
    name  = "management.type"
    value = "jdbc"
  }

  set {
    name  = "api.enabled"
    value = "false"
  }

  set {
    name  = "portal.enabled"
    value = "false"
  }

  set {
    name  = "ui.enabled"
    value = "false"
  }

  set {
    name  = "gateway.deployment.nodeSelector.node"
    value = "gravitee"
  }

  depends_on = [helm_release.pgsql]
}
