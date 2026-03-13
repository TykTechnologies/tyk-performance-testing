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

  # Ensure LoadBalancer type when using Local traffic policy
  actual_service_type = var.external_traffic_policy == "Local" ? "LoadBalancer" : var.service_type

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
    { name = "TYK_GW_OPENTELEMETRY_METRICS_ENABLED", value = tostring(var.open_telemetry.metrics_enabled) },
    { name = "TYK_GW_OPENTELEMETRY_METRICS_RUNTIMEMETRICS", value = tostring(var.open_telemetry.runtime_metrics) },
    { name = "TYK_GW_HTTPPROFILE", value = tostring(var.profiler.enabled) },
    # Aggressive timeouts for fast failure during node outages
    { name = "TYK_GW_HTTPSERVEROPTIONS_READTIMEOUT", value = "5" },
    # Per Tyk guidance, write_timeout should exceed proxy_default_timeout by >=1s
    # to avoid client-visible stalls when upstreams are unreachable
    { name = "TYK_GW_HTTPSERVEROPTIONS_WRITETIMEOUT", value = "6" },
    { name = "TYK_GW_PROXYDEFAULTTIMEOUT", value = "5" },
    { name = "TYK_GW_PROXYCLOSECONNECTIONS", value = "false" },  # Keep connection reuse enabled
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

# Note: Shared storage resources removed - using ConfigMaps instead
# ConfigMaps provide a simpler, more reliable solution for mounting
# API definitions to all pods without requiring special storage classes

resource "helm_release" "tyk" {
  name       = "tyk"
  repository = "https://helm.tyk.io/public/helm/charts"
  chart      = "tyk-stack"

  namespace = var.namespace
  atomic    = true
  wait          = true
  wait_for_jobs = true
  timeout       = 1800

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
    value = "true"
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
    value = local.actual_service_type
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

  # Health check configuration for better autoscaling
  set {
    name  = "tyk-gateway.gateway.livenessProbe.httpGet.path"
    value = "/hello"
  }

  set {
    name  = "tyk-gateway.gateway.livenessProbe.httpGet.port"
    value = "8080"
  }

  set {
    name  = "tyk-gateway.gateway.livenessProbe.initialDelaySeconds"
    value = "30"
  }

  set {
    name  = "tyk-gateway.gateway.livenessProbe.periodSeconds"
    value = "10"
  }

  set {
    name  = "tyk-gateway.gateway.livenessProbe.timeoutSeconds"
    value = "5"
  }

  set {
    name  = "tyk-gateway.gateway.readinessProbe.httpGet.path"
    value = "/hello"
  }

  set {
    name  = "tyk-gateway.gateway.readinessProbe.httpGet.port"
    value = "8080"
  }

  set {
    name  = "tyk-gateway.gateway.readinessProbe.initialDelaySeconds"
    value = "60"
  }

  set {
    name  = "tyk-gateway.gateway.readinessProbe.periodSeconds"
    value = "5"
  }

  set {
    name  = "tyk-gateway.gateway.readinessProbe.successThreshold"
    value = "1"
  }

  set {
    name  = "tyk-gateway.gateway.readinessProbe.failureThreshold"
    value = "3"
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

  # --- Node placement: choose the correct label key per provider ---
  # GKE: cloud.google.com/gke-nodepool (only when strategy is 'strict')
  dynamic "set" {
    for_each = var.cluster_type == "gke" && var.node_selector_strategy == "strict" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.nodeSelector.cloud\\.google\\.com/gke-nodepool"
      value = var.label
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "gke" && var.node_selector_strategy == "strict" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.nodeSelector.cloud\\.google\\.com/gke-nodepool"
      value = var.resources_label
    }
  }

  # Optional fallback: prefer the target GKE nodepool, but allow scheduling elsewhere
  dynamic "set" {
    for_each = var.cluster_type == "gke" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight"
      value = "100"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "gke" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].key"
      value = "cloud.google.com/gke-nodepool"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "gke" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].operator"
      value = "In"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "gke" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].values[0]"
      value = var.label
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "gke" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight"
      value = "100"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "gke" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].key"
      value = "cloud.google.com/gke-nodepool"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "gke" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].operator"
      value = "In"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "gke" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].values[0]"
      value = var.resources_label
    }
  }

  # AKS prefer mode - try agentpool first, fallback to any node
  dynamic "set" {
    for_each = var.cluster_type == "aks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight"
      value = "100"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "aks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].key"
      value = "agentpool"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "aks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].operator"
      value = "In"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "aks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].values[0]"
      value = var.label
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "aks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight"
      value = "100"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "aks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].key"
      value = "agentpool"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "aks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].operator"
      value = "In"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "aks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].values[0]"
      value = var.resources_label
    }
  }

  # AKS: agentpool (stable) / kubernetes.azure.com/nodepool (also exists)
  dynamic "set" {
    for_each = var.cluster_type == "aks" && var.node_selector_strategy == "strict" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.nodeSelector.agentpool"
      value = var.label
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "aks" && var.node_selector_strategy == "strict" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.nodeSelector.agentpool"
      value = var.resources_label
    }
  }

  # EKS prefer mode - try nodegroup first, fallback to any node
  dynamic "set" {
    for_each = var.cluster_type == "eks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight"
      value = "100"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "eks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].key"
      value = "eks.amazonaws.com/nodegroup"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "eks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].operator"
      value = "In"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "eks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].values[0]"
      value = var.label
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "eks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight"
      value = "100"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "eks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].key"
      value = "eks.amazonaws.com/nodegroup"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "eks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].operator"
      value = "In"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "eks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].values[0]"
      value = var.resources_label
    }
  }

  # EKS: eks.amazonaws.com/nodegroup
  dynamic "set" {
    for_each = var.cluster_type == "eks" && var.node_selector_strategy == "strict" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.nodeSelector.eks\\.amazonaws\\.com/nodegroup"
      value = var.label
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "eks" && var.node_selector_strategy == "strict" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.nodeSelector.eks\\.amazonaws\\.com/nodegroup"
      value = var.resources_label
    }
  }

  # Fallback: custom clusters where nodes are labeled as "node=<value>"
  dynamic "set" {
    for_each = contains(["gke","aks","eks"], var.cluster_type) == false && var.node_selector_strategy == "strict" ? [1] : []
    content {
      name  = "tyk-gateway.gateway.nodeSelector.node"
      value = var.label
    }
  }
  dynamic "set" {
    for_each = contains(["gke","aks","eks"], var.cluster_type) == false && var.node_selector_strategy == "strict" ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.nodeSelector.node"
      value = var.resources_label
    }
  }

  # Add tolerations for faster pod eviction during node failures (30s instead of 300s default)
  set {
    name  = "tyk-gateway.gateway.tolerations[0].key"
    value = "node.kubernetes.io/not-ready"
  }

  set {
    name  = "tyk-gateway.gateway.tolerations[0].operator"
    value = "Exists"
  }

  set {
    name  = "tyk-gateway.gateway.tolerations[0].effect"
    value = "NoExecute"
  }

  set {
    name  = "tyk-gateway.gateway.tolerations[0].tolerationSeconds"
    value = "30"
  }

  set {
    name  = "tyk-gateway.gateway.tolerations[1].key"
    value = "node.kubernetes.io/unreachable"
  }

  set {
    name  = "tyk-gateway.gateway.tolerations[1].operator"
    value = "Exists"
  }

  set {
    name  = "tyk-gateway.gateway.tolerations[1].effect"
    value = "NoExecute"
  }

  set {
    name  = "tyk-gateway.gateway.tolerations[1].tolerationSeconds"
    value = "30"
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

  # Pump node placement (match dashboard placement for shared resources) - only when strategy is 'strict'
  dynamic "set" {
    for_each = var.cluster_type == "gke" && var.node_selector_strategy == "strict" ? [1] : []
    content {
      name  = "tyk-pump.pump.nodeSelector.cloud\\.google\\.com/gke-nodepool"
      value = var.resources_label
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "aks" && var.node_selector_strategy == "strict" ? [1] : []
    content {
      name  = "tyk-pump.pump.nodeSelector.agentpool"
      value = var.resources_label
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "eks" && var.node_selector_strategy == "strict" ? [1] : []
    content {
      name  = "tyk-pump.pump.nodeSelector.eks\\.amazonaws\\.com/nodegroup"
      value = var.resources_label
    }
  }
  dynamic "set" {
    for_each = contains(["gke","aks","eks"], var.cluster_type) == false && var.node_selector_strategy == "strict" ? [1] : []
    content {
      name  = "tyk-pump.pump.nodeSelector.node"
      value = var.resources_label
    }
  }

  # Prefer pump on the same GKE nodepool in 'prefer' mode
  dynamic "set" {
    for_each = var.cluster_type == "gke" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-pump.pump.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight"
      value = "100"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "gke" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-pump.pump.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].key"
      value = "cloud.google.com/gke-nodepool"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "gke" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-pump.pump.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].operator"
      value = "In"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "gke" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-pump.pump.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].values[0]"
      value = var.resources_label
    }
  }

  # AKS prefer mode for pump - try agentpool first, fallback to any node
  dynamic "set" {
    for_each = var.cluster_type == "aks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-pump.pump.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight"
      value = "100"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "aks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-pump.pump.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].key"
      value = "agentpool"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "aks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-pump.pump.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].operator"
      value = "In"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "aks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-pump.pump.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].values[0]"
      value = var.resources_label
    }
  }

  # EKS prefer mode for pump - try nodegroup first, fallback to any node
  dynamic "set" {
    for_each = var.cluster_type == "eks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-pump.pump.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight"
      value = "100"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "eks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-pump.pump.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].key"
      value = "eks.amazonaws.com/nodegroup"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "eks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-pump.pump.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].operator"
      value = "In"
    }
  }
  dynamic "set" {
    for_each = var.cluster_type == "eks" && var.node_selector_strategy == "prefer" ? [1] : []
    content {
      name  = "tyk-pump.pump.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].preference.matchExpressions[0].values[0]"
      value = var.resources_label
    }
  }

  # Optional tolerations to match tainted nodes (enable with var.enable_tolerations)
  dynamic "set" {
    for_each = var.enable_tolerations ? [1] : []
    content {
      name  = "tyk-gateway.gateway.tolerations[0].key"
      value = var.node_taint_key
    }
  }
  dynamic "set" {
    for_each = var.enable_tolerations ? [1] : []
    content {
      name  = "tyk-gateway.gateway.tolerations[0].operator"
      value = var.node_taint_operator
    }
  }
  dynamic "set" {
    for_each = var.enable_tolerations ? [1] : []
    content {
      name  = "tyk-gateway.gateway.tolerations[0].value"
      value = var.node_taint_value
    }
  }
  dynamic "set" {
    for_each = var.enable_tolerations ? [1] : []
    content {
      name  = "tyk-gateway.gateway.tolerations[0].effect"
      value = var.node_taint_effect
    }
  }
  dynamic "set" {
    for_each = var.enable_tolerations ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.tolerations[0].key"
      value = var.node_taint_key
    }
  }
  dynamic "set" {
    for_each = var.enable_tolerations ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.tolerations[0].operator"
      value = var.node_taint_operator
    }
  }
  dynamic "set" {
    for_each = var.enable_tolerations ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.tolerations[0].value"
      value = var.node_taint_value
    }
  }
  dynamic "set" {
    for_each = var.enable_tolerations ? [1] : []
    content {
      name  = "tyk-dashboard.dashboard.tolerations[0].effect"
      value = var.node_taint_effect
    }
  }
  dynamic "set" {
    for_each = var.enable_tolerations ? [1] : []
    content {
      name  = "tyk-pump.pump.tolerations[0].key"
      value = var.node_taint_key
    }
  }
  dynamic "set" {
    for_each = var.enable_tolerations ? [1] : []
    content {
      name  = "tyk-pump.pump.tolerations[0].operator"
      value = var.node_taint_operator
    }
  }
  dynamic "set" {
    for_each = var.enable_tolerations ? [1] : []
    content {
      name  = "tyk-pump.pump.tolerations[0].value"
      value = var.node_taint_value
    }
  }
  dynamic "set" {
    for_each = var.enable_tolerations ? [1] : []
    content {
      name  = "tyk-pump.pump.tolerations[0].effect"
      value = var.node_taint_effect
    }
  }

  depends_on = [
    kubernetes_namespace.tyk,
    helm_release.tyk-redis,
    helm_release.tyk-pgsql
  ]
}
