terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.4"
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
    value = "true"
  }

  set {
    name  = "api.ingress.management.scheme"
    value = "http"
  }

  set {
    name  = "api.resources.limits.cpu"
    value = "0"
  }

  set {
    name  = "api.resources.limits.memory"
    value = "0"
  }

  set {
    name  = "api.resources.requests.cpu"
    value = "0"
  }

  set {
    name  = "api.resources.requests.memory"
    value = "0"
  }

  set {
    name  = "api.deployment.nodeSelector.node"
    value = var.resources-label
  }

  set {
    name  = "ui.enabled"
    value = "true"
  }

  set {
    name  = "ui.resources.limits.cpu"
    value = "0"
  }

  set {
    name  = "ui.resources.limits.memory"
    value = "0"
  }

  set {
    name  = "ui.resources.requests.cpu"
    value = "0"
  }

  set {
    name  = "ui.resources.requests.memory"
    value = "0"
  }

  set {
    name  = "ui.deployment.nodeSelector.node"
    value = var.resources-label
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

  set {
    name  = "elasticsearch.enabled"
    value = "true"
  }

  set {
    name  = "elasticsearch.master.resources.limits.cpu"
    value = "0"
  }

  set {
    name  = "elasticsearch.master.resources.limits.memory"
    value = "0"
  }

  set {
    name  = "elasticsearch.master.resources.requests.cpu"
    value = "0"
  }

  set {
    name  = "elasticsearch.master.resources.requests.memory"
    value = "0"
  }

  set {
    name  = "elasticsearch.master.nodeSelector.node"
    value = var.resources-label
  }

  set {
    name  = "elasticsearch.coordinating.replicaCount"
    value = 1
  }

  set {
    name  = "elasticsearch.coordinating.resources.limits.cpu"
    value = "0"
  }

  set {
    name  = "elasticsearch.coordinating.resources.limits.memory"
    value = "0"
  }

  set {
    name  = "elasticsearch.coordinating.resources.requests.cpu"
    value = "0"
  }

  set {
    name  = "elasticsearch.coordinating.resources.requests.memory"
    value = "0"
  }

  set {
    name  = "elasticsearch.coordinating.nodeSelector.node"
    value = var.resources-label
  }

  set {
    name  = "elasticsearch.ingest.replicaCount"
    value = 1
  }

  set {
    name  = "elasticsearch.ingest.resources.limits.cpu"
    value = "0"
  }

  set {
    name  = "elasticsearch.ingest.resources.limits.memory"
    value = "0"
  }

  set {
    name  = "elasticsearch.ingest.resources.requests.cpu"
    value = "0"
  }

  set {
    name  = "elasticsearch.ingest.resources.requests.memory"
    value = "0"
  }

  set {
    name  = "elasticsearch.ingest.nodeSelector.node"
    value = var.resources-label
  }

  set {
    name  = "elasticsearch.data.replicaCount"
    value = 1
  }

  set {
    name  = "elasticsearch.data.resources.limits.cpu"
    value = "0"
  }

  set {
    name  = "elasticsearch.data.resources.limits.memory"
    value = "0"
  }

  set {
    name  = "elasticsearch.data.resources.requests.cpu"
    value = "0"
  }

  set {
    name  = "elasticsearch.data.resources.requests.memory"
    value = "0"
  }

  set {
    name  = "elasticsearch.data.nodeSelector.node"
    value = var.resources-label
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
    name  = "gateway.type"
    value = var.deployment_type
  }

  set {
    name  = "gateway.replicaCount"
    value = var.replica_count
  }

  set {
    name  = "gateway.services.metrics.enabled"
    value = var.analytics.enabled
  }

  set {
    name  = "gateway.services.metrics.labels[0]"
    value = "local"
  }

  set {
    name  = "gateway.services.metrics.labels[1]"
    value = "remote"
  }

  set {
    name  = "gateway.services.metrics.labels[2]"
    value = "http_method"
  }

  set {
    name  = "gateway.services.metrics.labels[3]"
    value = "http_code"
  }

  set {
    name  = "gateway.services.metrics.labels[4]"
    value = "http_path"
  }

  set {
    name  = "gateway.services.metrics.labels[5]"
    value = "http_route"
  }

  set {
    name  = "gateway.service.externalTrafficPolicy"
    value = var.external_traffic_policy
  }

  set {
    name  = "gateway.resources.requests.cpu"
    value = var.resources.requests.cpu
  }

  set {
    name  = "gateway.resources.requests.memory"
    value = var.resources.requests.memory
  }

  set {
    name  = "gateway.resources.limits.cpu"
    value = var.resources.limits.cpu
  }

  set {
    name  = "gateway.resources.limits.memory"
    value = var.resources.limits.memory
  }

  set {
    name  = "gateway.deployment.nodeSelector.node"
    value = var.label
  }

  depends_on = [helm_release.gravitee-redis, helm_release.gravitee-pgsql, helm_release.gravitee-nginx]
}
