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

resource "kubernetes_namespace" "tyk" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "tyk" {
  name       = "tyk"
  repository = "https://helm.tyk.io/public/helm/charts"
  chart      = "tyk-stack"

  namespace = var.namespace
  atomic    = true

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
    name  = "global.license.operator"
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
    value = "${helm_release.tyk-redis.name}-redis-cluster.${var.namespace}.svc:${local.redis-port}"
  }

  set {
    name  = "global.redis.pass"
    value = local.redis-pass
  }

  set {
    name  = "global.redis.enableCluster"
    value = true
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
    name  = "tyk-gateway.gateway.service.type"
    value = var.service_type
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
    value = "GOMEMLIMIT"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[2].value"
    value = var.resources.limits.memory != "0" ? "${var.resources.limits.memory}B" : ""
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[3].name"
    value = "TYK_GW_MAXIDLECONNSPERHOST"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[3].value"
    type  = "string"
    value = "1000"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[4].name"
    value = "TYK_GW_MAXIDLECONNSPERHOST"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[4].value"
    type  = "string"
    value = "10000"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[5].name"
    value = "TYK_GW_ANALYTICSCONFIG_ENABLEMULTIPLEANALYTICSKEYS"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[5].value"
    type  = "string"
    value = "true"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[6].name"
    value = "TYK_GW_ANALYTICSCONFIG_SERIALIZERTYPE"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[6].value"
    value = "protobuf"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[7].name"
    value = "TYK_GW_STORAGE_MAXACTIVE"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[7].value"
    type  = "string"
    value = "10000"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[8].name"
    value = "TYK_GW_OPENTELEMETRY_ENABLED"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[8].value"
    type  = "string"
    value = var.open_telemetry.enabled
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[9].name"
    value = "TYK_GW_OPENTELEMETRY_SAMPLING_TYPE"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[9].value"
    value = "TraceIDRatioBased"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[10].name"
    value = "TYK_GW_OPENTELEMETRY_SAMPLING_RATIO"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[10].value"
    type  = "string"
    value = var.open_telemetry.sampling_ratio
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[11].name"
    value = "TYK_GW_OPENTELEMETRY_EXPORTER"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[11].value"
    value = "grpc"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[12].name"
    value = "TYK_GW_OPENTELEMETRY_ENDPOINT"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[12].value"
    value = "opentelemetry-collector.dependencies.svc:4317"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[13].name"
    value = "TYK_GW_HTTPPROFILE"
  }

  set {
    type  = "string"
    name  = "tyk-gateway.gateway.extraEnvs[13].value"
    value = var.profiler.enabled
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
    value = var.analytics.database.enabled || var.analytics.prometheus.enabled
  }

  set {
    name  = "tyk-pump.pump.backend[0]"
    value = var.analytics.database.enabled ? "postgres" : ""
  }

  set {
    name  = "tyk-pump.pump.backend[1]"
    value = var.analytics.prometheus.enabled ? "prometheus" : ""
  }

  set {
    name  = "tyk-pump.pump.nodeSelector.node"
    value = var.resources-label
  }

  depends_on = [kubernetes_namespace.tyk, helm_release.tyk-redis, helm_release.tyk-pgsql]
}
