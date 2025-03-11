resource "kubernetes_namespace" "upstream" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment" "fortio" {
  metadata {
    name      = "fortio"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "fortio"
      }
    }
    template {
      metadata {
        labels = {
          app = "fortio"
        }
      }
      spec {
        node_selector = {
          node = var.label
        }
        container {
          image = "fortio/fortio"
          name  = "fortio"
          args  = ["server"]
          port {
            container_port = 8080
            protocol       = "TCP"
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.upstream]
}

resource "kubernetes_service_v1" "fortio" {
  metadata {
    name      = "fortio-${count.index}"
    namespace = var.namespace
    labels = {
      app = "fortio"
    }
  }
  spec {
    type     = "ClusterIP"
    selector = {
      app = "fortio"
    }
    port {
      name        = "http"
      port        = 8080
      protocol    = "TCP"
      target_port = 8080
    }
  }

  count      = var.service_count
  depends_on = [kubernetes_deployment.fortio]
}

