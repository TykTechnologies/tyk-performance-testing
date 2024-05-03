resource "kubernetes_deployment" "posts-subgraph" {
  metadata {
    name      = "posts-subgraph"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "posts-subgraph"
      }
    }
    template {
      metadata {
        labels = {
          app = "posts-subgraph"
        }
      }
      spec {
        node_selector = {
          node = var.node_selector
        }
        container {
          image   = "zalbiraw/go-api-test-service:v3.0"
          name    = "posts-subgraph"
          command = ["./services/graphql-subgraphs/posts/server"]
          port {
            container_port = 4202
            protocol       = "TCP"
          }
          env {
            name  = "PORT"
            value = 4202
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "posts-subgraph" {
  metadata {
    name      = "posts-subgraph"
    namespace = var.namespace
    labels = {
      app = "posts-subgraph"
    }
  }
  spec {
    type     = "ClusterIP"
    selector = {
      app = "posts-subgraph"
    }
    port {
      name        = "http"
      port        = 4202
      protocol    = "TCP"
      target_port = 4202
    }
  }

  depends_on = [kubernetes_deployment.posts-subgraph]
}
