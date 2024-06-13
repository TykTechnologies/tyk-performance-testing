locals {
  pgsql-name = "kong-database"
  pgsql-user = "kong"
  pgsql-pass = "topsecretpassword"
  pgsql-port = "5432"
  redis-pass = "topsecretpassword"
  redis-port = "6379"
}

resource "kubernetes_namespace" "kong" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "kong" {
  name       = "kong"
  repository = "https://charts.konghq.com"
  chart      = "kong"

  namespace = var.namespace
  atomic    = true

  set {
    name  = "image.tag"
    value = var.gateway_version
  }

  #############################################################################
  # Performance
  #############################################################################

  set {
    name  = "env.nginx_worker_processes"
    value = "auto"
  }

  set {
    name  = "env.nginx_main_worker_rlimit_nofile"
    value = "auto"
  }

  set {
    name  = "env.nginx_events_worker_connections"
    value = "auto"
  }

  set {
    name  = "deployment.daemonset"
    value = var.deployment_type == "DaemonSet" ? true : false
  }

  set {
    name  = "replicaCount"
    value = var.replica_count
  }

  set {
    name  = "resources.requests.cpu"
    value = var.resources.requests.cpu
  }

  set {
    name  = "resources.requests.memory"
    value = var.resources.requests.memory
  }

  set {
    name  = "resources.limits.cpu"
    value = var.resources.limits.cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.resources.limits.memory
  }

  #############################################################################
  # Database
  #############################################################################

  set {
    name  = "postgresql.enabled"
    value = "false"
  }

  set {
    name  = "env.database"
    value = "postgres"
  }

  set {
    name  = "env.pg_database"
    value = local.pgsql-name
  }

  set {
    name  = "env.cassandra_contact_points"
    value = local.pgsql-name
  }

  #############################################################################
  # Postgres Connection
  #############################################################################

  set {
    name  = "env.pg_host"
    value = "${helm_release.kong-pgsql.name}-postgresql.${var.namespace}.svc"
  }

  set {
    name  = "env.pg_port"
    value = local.pgsql-port
  }

  set {
    name  = "env.pg_user"
    value = local.pgsql-user
  }

  set {
    name  = "env.pg_password"
    value = local.pgsql-pass
  }

  set {
    name  = "env.pg_ssl"
    value = "off"
  }

  set {
    name  = "env.pg_ssl_verify"
    value = "off"
  }

  #############################################################################
  # Kong services
  #############################################################################

  set {
    name  = "proxy.type"
    value = "ClusterIP"
  }

  set {
    name  = "admin.enabled"
    value = "false"
  }

  set {
    name  = "admin.type"
    value = "ClusterIP"
  }

  set {
    name  = "ingressController.enabled"
    value = "false"
  }

  set {
    name  = "portal.enabled"
    value = "false"
  }

  set {
    name  = "portalapi.enabled"
    value = "false"
  }

  set {
    name  = "nodeSelector.node"
    value = var.label
  }

  depends_on = [helm_release.kong-redis, helm_release.kong-pgsql]
}
