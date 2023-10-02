terraform {
  required_providers {
    kubectl = {
      source = "alekc/kubectl"
      version = ">= 2.0.2"
    }
  }
}

locals {
  pgsql-name = "gravitee-database"
  pgsql-user = "gravitee"
  pgsql-pass = "topsecretpassword"
  pgsql-port = "5432"
  redis-pass = "topsecretpassword"
  redis-port = "6379"
}

resource "helm_release" "gravitee" {
  name       = "gravitee"
  repository = "https://helm.gravitee.io"
  chart      = "apim"

  namespace        = var.namespace
  create_namespace = true
  atomic           = true

  #############################################################################
  # Turn components not being used
  #############################################################################

  set {
    name  = "api.enabled"
    value = "false"
  }

  set {
    name  = "ui.enabled"
    value = "false"
  }

  set {
    name  = "portal.enabled"
    value = "false"
  }

  #############################################################################
  # Database
  #############################################################################

  set {
    name  = "management.type"
    value = "jdbc"
  }

  set {
    name  = "jdbc.driver"
    value = "https://jdbc.postgresql.org/download/postgresql-42.2.23.jar"
  }

  set {
    name  = "jdbc.url"
    value = "jdbc:postgresql://${helm_release.gravitee-pgsql.name}-postgresql:${local.pgsql-port}/${local.pgsql-name}"
  }

  set {
    name  = "jdbc.username"
    value = local.pgsql-user
  }

  set {
    name  = "jdbc.password"
    value = local.pgsql-pass
  }

  #############################################################################
  # Rate Limiting
  #############################################################################

  set {
    name  = "ratelimit.type"
    value = "redis"
  }

  set {
    name  = "gateway.ratelimit.redis.host"
    value = "${helm_release.gravitee-redis.name}-master.${var.namespace}.svc"
  }

  set {
    name  = "gateway.ratelimit.redis.port"
    value = local.redis-port
  }

  set {
    name  = "gateway.ratelimit.redis.password"
    value = local.redis-pass
  }

  set {
    name  = "gateway.ratelimit.redis.ssl"
    value = "false"
  }

  #############################################################################
  # Gateway settings
  #############################################################################

  set {
    name  = "gateway.image.tag"
    value = var.gateway_version
  }

  set {
    name  = "gateway.services.sync.kubernetes.enabled"
    value = "true"
  }

  set {
    name  = "gateway.autoscaling.enabled"
    value = "false"
  }

  set {
    name  = "gateway.reporters.elasticsearch.enabled"
    value = "false"
  }

  set {
    name  = "gateway.deployment.nodeSelector.node"
    value = var.label
  }

  depends_on = [helm_release.gravitee-redis, helm_release.gravitee-pgsql]
}
