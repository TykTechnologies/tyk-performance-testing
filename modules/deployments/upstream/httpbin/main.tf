resource "kubernetes_deployment" "httpbin" {
  metadata {
    name      = "httpbin"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "httpbin"
      }
    }
    template {
      metadata {
        labels = {
          app = "httpbin"
        }
      }
      spec {
        node_selector = {
          node = var.node_selector
        }
        container {
          image = "zalbiraw/go-httpbin"
          name  = "httpbin"
          port {
            container_port = 8080
            protocol       = "TCP"
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "httpbin" {
  metadata {
    name      = "httpbin"
    namespace = var.namespace
    labels = {
      app = "httpbin"
    }
  }
  spec {
    type     = "ClusterIP"
    selector = {
      app = "httpbin"
    }
    port {
      name        = "http"
      port        = 8080
      protocol    = "TCP"
      target_port = 8080
    }
  }

  depends_on = [kubernetes_deployment.httpbin]
}
