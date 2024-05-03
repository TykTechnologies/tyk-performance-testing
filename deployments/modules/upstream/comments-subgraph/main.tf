resource "kubernetes_deployment" "users-subgraph" {
  metadata {
    name      = "users-subgraph"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "users-subgraph"
      }
    }
    template {
      metadata {
        labels = {
          app = "users-subgraph"
        }
      }
      spec {
        node_selector = {
          node = var.node_selector
        }
        container {
          image   = "zalbiraw/go-api-test-service:v3.0"
          name    = "users-subgraph"
          command = ["./services/graphql-subgraphs/users/server"]
          port {
            container_port = 4201
            protocol       = "TCP"
          }
          env {
            name  = "PORT"
            value = 4201
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "users-subgraph" {
  metadata {
    name      = "users-subgraph"
    namespace = var.namespace
    labels = {
      app = "users-subgraph"
    }
  }
  spec {
    type     = "ClusterIP"
    selector = {
      app = "users-subgraph"
    }
    port {
      name        = "http"
      port        = 4201
      protocol    = "TCP"
      target_port = 4201
    }
  }

  depends_on = [kubernetes_deployment.users-subgraph]
}
