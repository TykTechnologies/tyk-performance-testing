resource "kubernetes_horizontal_pod_autoscaler_v2" "gravitee-hpa" {
  metadata {
    name      = "gravitee-hpa"
    namespace = var.namespace
  }

  spec {
    min_replicas = var.replica_count
    max_replicas = var.hpa.max_replica_count

    scale_target_ref {
      api_version = "apps/v1"
      kind        = var.deployment_type
      name        = "gravitee-apim-gateway"
    }
    
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = var.hpa.avg_cpu_util_percentage
        }
      }
    }
  }

  count      = var.hpa.enabled ? 1 : 0
  depends_on = [helm_release.gravitee]
}
