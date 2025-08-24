resource "kubernetes_horizontal_pod_autoscaler_v2" "tyk-hpa" {
  metadata {
    name      = "tyk-hpa"
    namespace = var.namespace
  }

  spec {
    min_replicas = var.replica_count
    max_replicas = var.hpa.max_replica_count

    scale_target_ref {
      api_version = "apps/v1"
      kind        = var.deployment_type
      name        = "gateway-tyk-tyk-gateway"
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

    behavior {
      scale_up {
        stabilization_window_seconds = 0
        select_policy = "Max"
        policy {
          type           = "Pods"
          value          = 1
          period_seconds = 5
        }
      }
      
      scale_down {
        # Avoid runaway oscillations during transient dips caused by node loss
        stabilization_window_seconds = 15
        select_policy = "Min"
        policy {
          type           = "Pods"
          value          = 1
          period_seconds = 10
        }
      }
    }
  }

  count      = var.hpa.enabled ? 1 : 0
  depends_on = [kubernetes_namespace.tyk, helm_release.tyk]
}
