resource "kubernetes_deployment" "users-graphql" {
  metadata {
    name      = "users-graphql"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "users-graphql"
      }
    }
    template {
      metadata {
        labels = {
          app = "users-graphql"
        }
      }
      spec {
        node_selector = {
          node = var.node_selector
        }
        container {
          image   = "zalbiraw/go-api-test-service:v3.0"
          name    = "users-graphql"
          command = ["./services/graphql/users/server"]
          port {
            container_port = 4101
            protocol       = "TCP"
          }
          env {
            name  = "PORT"
            value = 4101
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "users-graphql" {
  metadata {
    name      = "users-graphql"
    namespace = var.namespace
    labels = {
      app = "users-graphql"
    }
  }
  spec {
    type     = "ClusterIP"
    selector = {
      app = "users-graphql"
    }
    port {
      name        = "http"
      port        = 4101
      protocol    = "TCP"
      target_port = 4101
    }
  }

  depends_on = [kubernetes_deployment.users-graphql]
}
