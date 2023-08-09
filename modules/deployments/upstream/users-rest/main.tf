resource "kubernetes_deployment" "users-rest" {
  metadata {
    name      = "users-rest"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "users-rest"
      }
    }
    template {
      metadata {
        labels = {
          app = "users-rest"
        }
      }
      spec {
        node_selector = {
          node = var.node_selector
        }
        container {
          image   = "zalbiraw/go-api-test-service:v3.0"
          name    = "users-rest"
          command = ["./services/rest/users/server"]
          port {
            container_port = 3101
            protocol       = "TCP"
          }
          env {
            name  = "PORT"
            value = 3101
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "users-rest" {
  metadata {
    name      = "users-rest"
    namespace = var.namespace
    labels = {
      app = "users-rest"
    }
  }
  spec {
    type     = "ClusterIP"
    selector = {
      app = "users-rest"
    }
    port {
      name        = "http"
      port        = 3101
      protocol    = "TCP"
      target_port = 3101
    }
  }

  depends_on = [kubernetes_deployment.users-rest]
}
