resource "kubernetes_deployment" "notifications-graphql" {
  metadata {
    name      = "notifications-graphql"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "notifications-graphql"
      }
    }
    template {
      metadata {
        labels = {
          app = "notifications-graphql"
        }
      }
      spec {
        node_selector = {
          node = var.node_selector
        }
        container {
          image   = "zalbiraw/go-api-test-service:v3.0"
          name    = "notifications-graphql"
          command = ["./services/graphql/notifications/server"]
          port {
            container_port = 4104
            protocol       = "TCP"
          }
          env {
            name  = "PORT"
            value = 4104
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "notifications-graphql" {
  metadata {
    name      = "notifications-graphql"
    namespace = var.namespace
    labels = {
      app = "notifications-graphql"
    }
  }
  spec {
    type     = "ClusterIP"
    selector = {
      app = "notifications-graphql"
    }
    port {
      name        = "http"
      port        = 4104
      protocol    = "TCP"
      target_port = 4104
    }
  }

  depends_on = [kubernetes_deployment.notifications-graphql]
}
