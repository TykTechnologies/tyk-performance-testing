resource "kubernetes_horizontal_pod_autoscaler_v2" "traefik-hpa" {
  metadata {
    name      = "traefik-hpa"
    namespace = var.namespace
  }

  spec {
    min_replicas = var.replica_count
    max_replicas = var.hpa.max_replica_count

    scale_target_ref {
      api_version = "apps/v1"
      kind        = var.deployment_type
      name        = "traefik-gateway"
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
    }
  }

  count      = var.hpa.enabled ? 1 : 0
  depends_on = [helm_release.traefik]
}
