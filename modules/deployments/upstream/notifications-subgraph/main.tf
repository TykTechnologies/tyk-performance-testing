resource "kubernetes_deployment" "notifications-subgraph" {
  metadata {
    name      = "notifications-subgraph"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "notifications-subgraph"
      }
    }
    template {
      metadata {
        labels = {
          app = "notifications-subgraph"
        }
      }
      spec {
        node_selector = {
          node = var.node_selector
        }
        container {
          image   = "zalbiraw/go-api-test-service:v3.0"
          name    = "notifications-subgraph"
          command = ["./services/graphql-subgraphs/notifications/server"]
          port {
            container_port = 4204
            protocol       = "TCP"
          }
          env {
            name  = "PORT"
            value = 4204
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "notifications-subgraph" {
  metadata {
    name      = "notifications-subgraph"
    namespace = var.namespace
    labels = {
      app = "notifications-subgraph"
    }
  }
  spec {
    type     = "ClusterIP"
    selector = {
      app = "notifications-subgraph"
    }
    port {
      name        = "http"
      port        = 4204
      protocol    = "TCP"
      target_port = 4204
    }
  }

  depends_on = [kubernetes_deployment.notifications-subgraph]
}
