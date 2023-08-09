resource "kubernetes_deployment" "comments-rest" {
  metadata {
    name      = "comments-rest"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "comments-rest"
      }
    }
    template {
      metadata {
        labels = {
          app = "comments-rest"
        }
      }
      spec {
        node_selector = {
          node = var.node_selector
        }
        container {
          image   = "zalbiraw/go-api-test-service:v3.0"
          name    = "comments-rest"
          command = ["./services/rest/comments/server"]
          port {
            container_port = 3103
            protocol       = "TCP"
          }
          env {
            name  = "PORT"
            value = 3103
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "comments-rest" {
  metadata {
    name      = "comments-rest"
    namespace = var.namespace
    labels = {
      app = "comments-rest"
    }
  }
  spec {
    type     = "ClusterIP"
    selector = {
      app = "comments-rest"
    }
    port {
      name        = "http"
      port        = 3103
      protocol    = "TCP"
      target_port = 3103
    }
  }

  depends_on = [kubernetes_deployment.comments-rest]
}
