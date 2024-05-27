
resource "kubernetes_deployment" "fortio-server" {
  metadata {
    name      = "fortio-server"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "fortio-server"
      }
    }
    template {
      metadata {
        labels = {
          app = "fortio-server"
        }
      }
      spec {
        node_selector = {
          node = var.node_selector
        }
        container {
          args = ["server"]
          image = "fortio/fortio"
          name  = "fortio-server"
          port {
            container_port = 8080
            protocol       = "TCP"
          }
          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "fortio-server" {
  metadata {
    name      = "fortio-server"
    namespace = var.namespace
    labels = {
      app = "fortio-server"
    }
  }
  spec {
    type     = "ClusterIP"
    selector = {
      app = "fortio-server"
    }
    port {
      name        = "http"
      port        = 8080
      protocol    = "TCP"
      target_port = 8080
    }
  }

  depends_on = [kubernetes_deployment.fortio-server]
}
