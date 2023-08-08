resource "kubernetes_deployment" "posts-graphql" {
  metadata {
    name      = "posts-graphql"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "posts-graphql"
      }
    }
    template {
      metadata {
        labels = {
          app = "posts-graphql"
        }
      }
      spec {
        node_selector = {
          node = var.node_selector
        }
        container {
          image   = "zalbiraw/go-api-test-service:v3.0"
          name    = "posts-graphql"
          command = ["./services/graphql/posts/server"]
          port {
            container_port = 4102
            protocol       = "TCP"
          }
          env {
            name  = "PORT"
            value = 4102
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "posts-graphql" {
  metadata {
    name      = "posts-graphql"
    namespace = var.namespace
    labels = {
      app = "posts-graphql"
    }
  }
  spec {
    type     = "ClusterIP"
    selector = {
      app = "posts-graphql"
    }
    port {
      name        = "http"
      port        = 4102
      protocol    = "TCP"
      target_port = 4102
    }
  }

  depends_on = [kubernetes_deployment.posts-graphql]
}
