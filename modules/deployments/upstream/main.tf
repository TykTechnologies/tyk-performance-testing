resource "kubernetes_namespace" "upstream" {
  metadata {
    name = "upstream"
  }
}

resource "kubernetes_deployment" "httpbin" {
  metadata {
    name      = "httpbin"
    namespace = "upstream"
  }
  spec {
    selector {
      match_labels = {
        app     = "httpbin"
        version = "v1"
      }
    }
    template {
      metadata {
        labels = {
          app     = "httpbin"
          version = "v1"
        }
      }
      spec {
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
    namespace = "upstream"
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
      port        = 8000
      protocol    = "TCP"
      target_port = 8080
    }
  }
}
