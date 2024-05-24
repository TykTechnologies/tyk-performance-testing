terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.4"
    }
  }
}

locals {
  pgsql-name = "tyk-database"
  pgsql-user = "tyk"
  pgsql-pass = "topsecretpassword"
  pgsql-port = "5432"
  redis-pass = "topsecretpassword"
  redis-port = "6379"
}

resource "helm_release" "tyk" {
  name       = "tyk"
  repository = "https://helm.tyk.io/public/helm/charts"
  chart      = "tyk-stack"

  namespace        = var.namespace
  create_namespace = true
  atomic           = true

  set {
    name  = "global.adminUser.email"
    value = "default@example.com"
  }

  set {
    name  = "global.adminUser.password"
    value = "topsecretpassword"
  }

  set {
    name  = "global.storageType"
    value = "postgres"
  }

  set {
    name  = "global.license.dashboard"
    value = var.license
  }

  set {
    name  = "global.postgres.host"
    value = "${helm_release.tyk-pgsql.name}-postgresql"
  }

  set {
    name  = "global.postgres.port"
    value = local.pgsql-port
  }

  set {
    name  = "global.postgres.database"
    value = local.pgsql-name
  }

  set {
    name  = "global.postgres.password"
    value = local.pgsql-pass
  }

  set {
    name  = "global.postgres.sslmode"
    value = "disable"
  }

  set {
    name  = "global.redis.addrs[0]"
    value = "${helm_release.tyk-redis.name}-master.${var.namespace}.svc:${local.redis-port}"
  }

  set {
    name  = "global.redis.pass"
    value = local.redis-pass
  }

  set {
    name  = "tyk-dashboard.dashboard.image.tag"
    value = var.gateway_version
  }

  set {
    name  = "tyk-gateway.gateway.image.tag"
    value = var.gateway_version
  }

  set {
    name  = "tyk-gateway.gateway.kind"
    value = var.deployment_type
  }

  set {
    name  = "tyk-gateway.gateway.replicaCount"
    value = var.replica_count
  }

  set {
    name  = "tyk-gateway.gateway.service.externalTrafficPolicy"
    value = var.external_traffic_policy
  }

  set {
    name  = "tyk-gateway.gateway.resources.requests.cpu"
    value = var.resources.requests.cpu
  }

  set {
    name  = "tyk-gateway.gateway.resources.requests.memory"
    value = var.resources.requests.memory
  }

  set {
    name  = "tyk-gateway.gateway.resources.limits.cpu"
    value = var.resources.limits.cpu
  }

  set {
    name  = "tyk-gateway.gateway.resources.limits.memory"
    value = var.resources.limits.memory
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[0].name"
    value = "GOGC"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[0].value"
    type  = "string"
    value = var.go_gc
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[1].name"
    value = "GOMAXPROCS"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[1].value"
    type  = "string"
    value = var.go_max_procs
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[2].name"
    value = "TYK_GW_OPENTELEMETRY_ENABLED"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[2].value"
    type  = "string"
    value = var.open_telemetry.enabled
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[3].name"
    value = "TYK_GW_OPENTELEMETRY_SAMPLING_TYPE"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[3].value"
    value = "TraceIDRatioBased"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[4].name"
    value = "TYK_GW_OPENTELEMETRY_SAMPLING_RATIO"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[4].value"
    type  = "string"
    value = var.open_telemetry.sampling_ratio
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[5].name"
    value = "TYK_GW_OPENTELEMETRY_EXPORTER"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[5].value"
    value = "grpc"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[6].name"
    value = "TYK_GW_OPENTELEMETRY_ENDPOINT"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[6].value"
    value = "opentelemetry-collector.dependencies.svc:4317"
  }

  set {
    name  = "tyk-gateway.gateway.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "tyk-dashboard.dashboard.nodeSelector.node"
    value = var.resources-label
  }

  set {
    name  = "global.components.pump"
    value = var.analytics.enabled
  }

  set {
    name  = "tyk-pump.pump.backend[0]"
    value = "prometheus"
  }

  set {
    name  = "tyk-pump.pump.nodeSelector.node"
    value = var.resources-label
  }

  depends_on = [helm_release.tyk-redis, helm_release.tyk-pgsql]
}
