resource "kubernetes_deployment" "comments-graphql" {
  metadata {
    name      = "comments-graphql"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "comments-graphql"
      }
    }
    template {
      metadata {
        labels = {
          app = "comments-graphql"
        }
      }
      spec {
        node_selector = {
          node = var.node_selector
        }
        container {
          image   = "zalbiraw/go-api-test-service:v3.0"
          name    = "comments-graphql"
          command = ["./services/graphql/comments/server"]
          port {
            container_port = 4103
            protocol       = "TCP"
          }
          env {
            name  = "PORT"
            value = 4103
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "comments-graphql" {
  metadata {
    name      = "comments-graphql"
    namespace = var.namespace
    labels = {
      app = "comments-graphql"
    }
  }
  spec {
    type     = "ClusterIP"
    selector = {
      app = "comments-graphql"
    }
    port {
      name        = "http"
      port        = 4103
      protocol    = "TCP"
      target_port = 4103
    }
  }

  depends_on = [kubernetes_deployment.comments-graphql]
}
