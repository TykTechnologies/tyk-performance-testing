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

  # Build all Gateway extra envs as a single list to avoid sparse indices
  tyk_gateway_extra_envs_base = [
    { name = "GOGC", value = tostring(var.go_gc) },
    { name = "GOMAXPROCS", value = tostring(var.go_max_procs) },
    { name = "GOMEMLIMIT", value = var.resources.limits.memory != "0" ? "${var.resources.limits.memory}B" : "" },
    { name = "TYK_GW_MAXIDLECONNSPERHOST", value = "1000" },
    { name = "TYK_GW_MAXCONNSPERHOST", value = "10000" },
    { name = "TYK_GW_ANALYTICSCONFIG_ENABLEMULTIPLEANALYTICSKEYS", value = "true" },
    { name = "TYK_GW_ANALYTICSCONFIG_SERIALIZERTYPE", value = "protobuf" },
    { name = "TYK_GW_STORAGE_MAXACTIVE", value = "10000" },
    { name = "TYK_GW_OPENTELEMETRY_ENABLED", value = tostring(var.open_telemetry.enabled) },
    { name = "TYK_GW_OPENTELEMETRY_SAMPLING_TYPE", value = "TraceIDRatioBased" },
    { name = "TYK_GW_OPENTELEMETRY_SAMPLING_RATIO", value = tostring(var.open_telemetry.sampling_ratio) },
    { name = "TYK_GW_OPENTELEMETRY_EXPORTER", value = "grpc" },
    { name = "TYK_GW_OPENTELEMETRY_ENDPOINT", value = "opentelemetry-collector.dependencies.svc:4317" },
    { name = "TYK_GW_HTTPPROFILE", value = tostring(var.profiler.enabled) },
  ]

  tyk_gateway_extra_envs_cfgmap = var.use_config_maps_for_apis ? [
    { name = "TYK_GW_APPPATH", value = "/opt/tyk-gateway/apps" },
    { name = "TYK_GW_POLICIES_POLICYPATH", value = "/opt/tyk-gateway/policies" },
    { name = "TYK_GW_POLICIES_POLICYSOURCE", value = "file" },
    { name = "TYK_GW_USEDBAPPCONFIGS", value = "false" },
  ] : []

  tyk_gateway_extra_envs = concat(local.tyk_gateway_extra_envs_base, local.tyk_gateway_extra_envs_cfgmap)
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

  # Provide extraEnvs as a single list to Helm to avoid null/empty entries
  values = [
    yamlencode({
      "tyk-gateway" = {
        gateway = {
          extraEnvs = local.tyk_gateway_extra_envs
        }
      }
    })
  ]

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


  # Mount API definitions ConfigMap
  dynamic "set" {
    for_each = var.use_config_maps_for_apis ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraVolumes[0].name"
      value = "api-definitions"
    }
  }

  dynamic "set" {
    for_each = var.use_config_maps_for_apis ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraVolumes[0].configMap.name"
      value = "tyk-api-definitions"
    }
  }

  dynamic "set" {
    for_each = var.use_config_maps_for_apis ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraVolumes[0].configMap.defaultMode"
      value = 420
    }
  }

  dynamic "set" {
    for_each = var.use_config_maps_for_apis ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraVolumeMounts[0].name"
      value = "api-definitions"
    }
  }

  dynamic "set" {
    for_each = var.use_config_maps_for_apis ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraVolumeMounts[0].mountPath"
      value = "/opt/tyk-gateway/apps"
    }
  }

  dynamic "set" {
    for_each = var.use_config_maps_for_apis ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraVolumeMounts[0].readOnly"
      value = "true"
    }
  }

  # Mount policy definitions ConfigMap if policies are enabled
  dynamic "set" {
    for_each = var.use_config_maps_for_apis && (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraVolumes[1].name"
      value = "policy-definitions"
    }
  }

  dynamic "set" {
    for_each = var.use_config_maps_for_apis && (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraVolumes[1].configMap.name"
      value = "tyk-policy-definitions"
    }
  }

  dynamic "set" {
    for_each = var.use_config_maps_for_apis && (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraVolumes[1].configMap.defaultMode"
      value = 420
    }
  }

  dynamic "set" {
    for_each = var.use_config_maps_for_apis && (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraVolumeMounts[1].name"
      value = "policy-definitions"
    }
  }

  dynamic "set" {
    for_each = var.use_config_maps_for_apis && (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraVolumeMounts[1].mountPath"
      value = "/opt/tyk-gateway/policies"
    }
  }

  dynamic "set" {
    for_each = var.use_config_maps_for_apis && (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraVolumeMounts[1].readOnly"
      value = "true"
    }
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
