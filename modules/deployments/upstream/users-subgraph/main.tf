resource "kubernetes_deployment" "comments-subgraph" {
  metadata {
    name      = "comments-subgraph"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "comments-subgraph"
      }
    }
    template {
      metadata {
        labels = {
          app = "comments-subgraph"
        }
      }
      spec {
        node_selector = {
          node = var.node_selector
        }
        container {
          image   = "zalbiraw/go-api-test-service:v3.0"
          name    = "comments-subgraph"
          command = ["./services/graphql-subgraphs/comments/server"]
          port {
            container_port = 4203
            protocol       = "TCP"
          }
          env {
            name  = "PORT"
            value = 4203
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "comments-subgraph" {
  metadata {
    name      = "comments-subgraph"
    namespace = var.namespace
    labels = {
      app = "comments-subgraph"
    }
  }
  spec {
    type     = "ClusterIP"
    selector = {
      app = "comments-subgraph"
    }
    port {
      name        = "http"
      port        = 4203
      protocol    = "TCP"
      target_port = 4203
    }
  }

  depends_on = [kubernetes_deployment.comments-subgraph]
}
