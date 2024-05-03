resource "kubernetes_deployment" "timestamp" {
  metadata {
    name      = "timestamp"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "timestamp"
      }
    }
    template {
      metadata {
        labels = {
          app = "timestamp"
        }
      }
      spec {
        node_selector = {
          node = var.node_selector
        }
        container {
          image   = "zalbiraw/go-api-test-service:v3.0"
          name    = "timestamp"
          command = ["./services/rest/rest/server"]
          port {
            container_port = 3100
            protocol       = "TCP"
          }
          env {
            name  = "PORT"
            value = 3100
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "timestamp" {
  metadata {
    name      = "timestamp"
    namespace = var.namespace
    labels = {
      app = "timestamp"
    }
  }
  spec {
    type     = "ClusterIP"
    selector = {
      app = "timestamp"
    }
    port {
      name        = "http"
      port        = 3100
      protocol    = "TCP"
      target_port = 3100
    }
  }

  depends_on = [kubernetes_deployment.timestamp]
}
