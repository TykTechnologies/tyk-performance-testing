resource "kubernetes_deployment" "posts-rest" {
  metadata {
    name      = "posts-rest"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "posts-rest"
      }
    }
    template {
      metadata {
        labels = {
          app = "posts-rest"
        }
      }
      spec {
        node_selector = {
          node = var.node_selector
        }
        container {
          image   = "zalbiraw/go-api-test-service:v3.0"
          name    = "posts-rest"
          command = ["./services/rest/posts/server"]
          port {
            container_port = 3102
            protocol       = "TCP"
          }
          env {
            name  = "PORT"
            value = 3102
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "posts-rest" {
  metadata {
    name      = "posts-rest"
    namespace = var.namespace
    labels = {
      app = "posts-rest"
    }
  }
  spec {
    type     = "ClusterIP"
    selector = {
      app = "posts-rest"
    }
    port {
      name        = "http"
      port        = 3102
      protocol    = "TCP"
      target_port = 3102
    }
  }

  depends_on = [kubernetes_deployment.posts-rest]
}
