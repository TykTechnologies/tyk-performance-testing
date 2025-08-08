resource "kubernetes_deployment" "scaling-webhook" {
  count = var.scaling_webhook.enabled ? 1 : 0
  
  metadata {
    name      = "scaling-webhook"
    namespace = "dependencies"
    labels = {
      app = "scaling-webhook"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "scaling-webhook"
      }
    }

    template {
      metadata {
        labels = {
          app = "scaling-webhook"
        }
      }

      spec {
        service_account_name            = kubernetes_service_account.scaling-webhook[0].metadata[0].name
        automount_service_account_token = true
        
        container {
          image = "golang:1.21-alpine"
          name  = "scaling-webhook"
          
          command = ["/bin/sh"]
          args = ["-c", "apk add --no-cache curl && go run /app/main.go"]

          port {
            container_port = 8080
          }

          env {
            name = "CLUSTER_TYPE"
            value = var.scaling_webhook.cluster_type
          }
          
          env {
            name = "AWS_REGION"
            value = var.scaling_webhook.aws_region
          }
          
          env {
            name = "EKS_CLUSTER_NAME"
            value = "pt-${var.scaling_webhook.aws_region}"
          }

          volume_mount {
            name       = "webhook-code"
            mount_path = "/app"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "256Mi"
            }
          }
        }

        volume {
          name = "webhook-code"
          config_map {
            name = kubernetes_config_map.scaling-webhook-code[0].metadata[0].name
            default_mode = "0755"
          }
        }

        node_selector = {
          node = "dependencies"
        }
      }
    }
  }

  depends_on = [
    kubernetes_config_map.scaling-webhook-code,
    kubernetes_service_account.scaling-webhook,
    kubernetes_cluster_role_binding.scaling-webhook
  ]
}

resource "kubernetes_service" "scaling-webhook" {
  count = var.scaling_webhook.enabled ? 1 : 0
  
  metadata {
    name      = "scaling-webhook"
    namespace = "dependencies"
  }

  spec {
    selector = {
      app = "scaling-webhook"
    }

    port {
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service_account" "scaling-webhook" {
  count = var.scaling_webhook.enabled ? 1 : 0
  
  metadata {
    name      = "scaling-webhook"
    namespace = "dependencies"
  }
}

resource "kubernetes_cluster_role" "scaling-webhook" {
  count = var.scaling_webhook.enabled ? 1 : 0
  
  metadata {
    name = "scaling-webhook"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get", "list", "watch"]
  }
  
  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets"]
    verbs      = ["get", "list", "patch", "update"]
  }
}

resource "kubernetes_cluster_role_binding" "scaling-webhook" {
  count = var.scaling_webhook.enabled ? 1 : 0
  
  metadata {
    name = "scaling-webhook"
  }
  
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.scaling-webhook[0].metadata[0].name
  }
  
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.scaling-webhook[0].metadata[0].name
    namespace = "dependencies"
  }
}

resource "kubernetes_config_map" "scaling-webhook-code" {
  count = var.scaling_webhook.enabled ? 1 : 0
  
  metadata {
    name      = "scaling-webhook-code"
    namespace = "dependencies"
  }

  data = {
    "main.go" = <<EOF
package main

import (
    "context"
    "encoding/json"
    "fmt"
    "log"
    "net/http"
    "os"
    "os/exec"
    "strconv"
    "strings"
)

type ScaleRequest struct {
    Action        string `json:"action"`
    Target        string `json:"target"`
    NodesToAdd    int    `json:"nodes_to_add,omitempty"`
    NodesToRemove int    `json:"nodes_to_remove,omitempty"`
    ClusterType   string `json:"cluster_type"`
}

type ScaleResponse struct {
    Status  string `json:"status"`
    Message string `json:"message"`
}

func main() {
    http.HandleFunc("/scale", handleScale)
    http.HandleFunc("/health", handleHealth)
    
    log.Println("Scaling webhook starting on :8080")
    log.Fatal(http.ListenAndServe(":8080", nil))
}

func handleHealth(w http.ResponseWriter, r *http.Request) {
    w.WriteHeader(http.StatusOK)
    json.NewEncoder(w).Encode(map[string]string{"status": "healthy"})
}

func handleScale(w http.ResponseWriter, r *http.Request) {
    if r.Method != http.MethodPost {
        http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
        return
    }

    var req ScaleRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        http.Error(w, "Invalid JSON", http.StatusBadRequest)
        return
    }

    log.Printf("Received scaling request: %+v", req)

    var err error
    var message string

    switch req.ClusterType {
    case "eks":
        err, message = scaleEKSNodeGroup(req)
    case "aks":
        err, message = scaleAKSNodePool(req)
    case "gke":
        err, message = scaleGKENodePool(req)
    default:
        http.Error(w, "Unsupported cluster type", http.StatusBadRequest)
        return
    }

    if err != nil {
        log.Printf("Scaling failed: %v", err)
        w.WriteHeader(http.StatusInternalServerError)
        json.NewEncoder(w).Encode(ScaleResponse{
            Status:  "error",
            Message: err.Error(),
        })
        return
    }

    w.WriteHeader(http.StatusAccepted)
    json.NewEncoder(w).Encode(ScaleResponse{
        Status:  "accepted",
        Message: message,
    })
}

func scaleEKSNodeGroup(req ScaleRequest) (error, string) {
    clusterName := os.Getenv("EKS_CLUSTER_NAME")
    if clusterName == "" {
        return fmt.Errorf("EKS_CLUSTER_NAME not set"), ""
    }

    region := os.Getenv("AWS_REGION")
    if region == "" {
        region = "us-west-2" // default
    }

    // Get current node group info
    nodeGroupName := req.Target + "-node-group"
    
    var newSize int
    if req.Action == "scale_up" {
        // Get current desired capacity and add nodes
        cmd := exec.Command("aws", "eks", "describe-nodegroup",
            "--cluster-name", clusterName,
            "--nodegroup-name", nodeGroupName,
            "--region", region,
            "--query", "nodegroup.scalingConfig.desiredSize",
            "--output", "text")
        
        output, err := cmd.Output()
        if err != nil {
            return err, ""
        }
        
        currentSize, err := strconv.Atoi(strings.TrimSpace(string(output)))
        if err != nil {
            return err, ""
        }
        
        newSize = currentSize + req.NodesToAdd
    } else if req.Action == "scale_down" {
        // Get current desired capacity and remove nodes
        cmd := exec.Command("aws", "eks", "describe-nodegroup",
            "--cluster-name", clusterName,
            "--nodegroup-name", nodeGroupName,
            "--region", region,
            "--query", "nodegroup.scalingConfig.desiredSize",
            "--output", "text")
        
        output, err := cmd.Output()
        if err != nil {
            return err, ""
        }
        
        currentSize, err := strconv.Atoi(strings.TrimSpace(string(output)))
        if err != nil {
            return err, ""
        }
        
        newSize = currentSize - req.NodesToRemove
        if newSize < 1 {
            newSize = 1 // Minimum of 1 node
        }
    }

    // Update node group
    cmd := exec.Command("aws", "eks", "update-nodegroup-config",
        "--cluster-name", clusterName,
        "--nodegroup-name", nodeGroupName,
        "--region", region,
        "--scaling-config", fmt.Sprintf("desiredSize=%d", newSize))

    if err := cmd.Run(); err != nil {
        return err, ""
    }

    return nil, fmt.Sprintf("EKS node group %s scaled to %d nodes", nodeGroupName, newSize)
}

func scaleAKSNodePool(req ScaleRequest) (error, string) {
    // Implementation for AKS scaling
    return fmt.Errorf("AKS scaling not implemented yet"), ""
}

func scaleGKENodePool(req ScaleRequest) (error, string) {
    // Implementation for GKE scaling  
    return fmt.Errorf("GKE scaling not implemented yet"), ""
}
EOF
    
    "go.mod" = <<EOF
module scaling-webhook

go 1.21
EOF
  }
}