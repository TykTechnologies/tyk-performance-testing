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

# Create a StorageClass for RWX support based on cloud provider
resource "kubernetes_storage_class" "tyk-rwx" {
  count = var.enable_shared_storage ? 1 : 0
  
  metadata {
    name = "tyk-rwx-storage"
  }
  
  # GKE: Use Filestore CSI driver
  storage_provisioner = var.cluster_type == "gke" ? "filestore.csi.storage.gke.io" : (
    # EKS: Use EFS CSI driver  
    var.cluster_type == "eks" ? "efs.csi.aws.com" : (
      # AKS: Use Azure Files
      var.cluster_type == "aks" ? "file.csi.azure.com" : "standard"
    )
  )
  
  reclaim_policy = "Delete"
  volume_binding_mode = "Immediate"
  
  parameters = var.cluster_type == "gke" ? {
    tier = "standard"  # Use "enterprise" for better performance
    network = "default"
  } : var.cluster_type == "aks" ? {
    skuName = "Standard_LRS"
  } : {}
}

resource "kubernetes_persistent_volume_claim" "tyk-api-definitions" {
  count = var.enable_shared_storage ? 1 : 0
  
  metadata {
    name      = "tyk-api-definitions-pvc"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = var.cluster_type == "gke" ? "1Ti" : "1Gi"  # GKE Filestore min is 1TB
      }
    }
    storage_class_name = kubernetes_storage_class.tyk-rwx[0].metadata[0].name
  }
  depends_on = [kubernetes_namespace.tyk, kubernetes_storage_class.tyk-rwx]
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

  # Mount API definitions from ConfigMap when using file-based approach
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
      value = kubernetes_config_map.api-definitions[0].metadata[0].name
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
      value = "/mnt/tyk-gateway/apps"
    }
  }

  # Mount policy definitions from ConfigMap when using file-based approach with auth/rate-limit/quota
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
      value = kubernetes_config_map.policy-definitions[0].metadata[0].name
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
      value = "/mnt/tyk-gateway/policies"
    }
  }

  # Configure gateway to use the shared apps folder
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
    value = "10000"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[4].name"
    value = "TYK_GW_ANALYTICSCONFIG_ENABLEMULTIPLEANALYTICSKEYS"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[4].value"
    type  = "string"
    value = "true"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[5].name"
    value = "TYK_GW_ANALYTICSCONFIG_SERIALIZERTYPE"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[5].value"
    value = "protobuf"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[6].name"
    value = "TYK_GW_STORAGE_MAXACTIVE"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[6].value"
    type  = "string"
    value = "10000"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[7].name"
    value = "TYK_GW_OPENTELEMETRY_ENABLED"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[7].value"
    type  = "string"
    value = var.open_telemetry.enabled
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[8].name"
    value = "TYK_GW_OPENTELEMETRY_SAMPLING_TYPE"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[8].value"
    value = "TraceIDRatioBased"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[9].name"
    value = "TYK_GW_OPENTELEMETRY_SAMPLING_RATIO"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[9].value"
    type  = "string"
    value = var.open_telemetry.sampling_ratio
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[10].name"
    value = "TYK_GW_OPENTELEMETRY_EXPORTER"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[10].value"
    value = "grpc"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[11].name"
    value = "TYK_GW_OPENTELEMETRY_ENDPOINT"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[11].value"
    value = "opentelemetry-collector.dependencies.svc:4317"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[12].name"
    value = "TYK_GW_HTTPPROFILE"
  }

  set {
    type  = "string"
    name  = "tyk-gateway.gateway.extraEnvs[12].value"
    value = var.profiler.enabled
  }

  # Configure gateway to use file-based API definitions when ConfigMaps are used
  dynamic "set" {
    for_each = var.use_config_maps_for_apis ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraEnvs[13].name"
      value = "TYK_GW_APPPATH"
    }
  }

  dynamic "set" {
    for_each = var.use_config_maps_for_apis ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraEnvs[13].value"
      value = "/mnt/tyk-gateway/apps"
    }
  }

  # Configure gateway to use file-based policies when ConfigMaps are used
  dynamic "set" {
    for_each = var.use_config_maps_for_apis && (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraEnvs[14].name"
      value = "TYK_GW_POLICIES_POLICYPATH"
    }
  }

  dynamic "set" {
    for_each = var.use_config_maps_for_apis && (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? [1] : []
    content {
      name  = "tyk-gateway.gateway.extraEnvs[14].value"
      value = "/mnt/tyk-gateway/policies"
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
