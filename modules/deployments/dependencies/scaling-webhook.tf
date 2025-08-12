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
          args = ["-c", <<-EOF
            set -x  # Show commands being executed
            echo "=== Starting scaling webhook container ==="
            echo "Installing curl..."
            apk add --no-cache curl
            echo "Checking /app directory contents:"
            ls -la /app/
            echo "Checking if go is available:"
            which go
            go version
            echo "Checking Go code syntax:"
            cd /app
            cat main.go | head -30
            echo "Attempting to compile webhook..."
            go build -v -o webhook main.go 2>&1 || {
              echo "=== COMPILATION FAILED ==="
              echo "Error output:"
              go build -v -o webhook main.go
              echo "=== Attempting go vet for more details ==="
              go vet main.go
              echo "=== Attempting gofmt check ==="
              gofmt -d main.go
              exit 1
            }
            echo "Compilation successful! Starting webhook server..."
            ./webhook
          EOF
          ]

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
          
          env {
            name = "GKE_CLUSTER_NAME"
            value = "pt-${var.scaling_webhook.gcp_region}"
          }
          
          env {
            name = "GCP_REGION"
            value = var.scaling_webhook.gcp_region
          }

          volume_mount {
            name       = "webhook-code"
            mount_path = "/app"
          }

          resources {
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
          
# Temporarily disabled health probes to debug startup issues
          # liveness_probe {
          #   http_get {
          #     path = "/health"
          #     port = 8080
          #   }
          #   initial_delay_seconds = 90
          #   period_seconds        = 10
          #   timeout_seconds       = 5
          #   failure_threshold     = 3
          # }
          
          # readiness_probe {
          #   http_get {
          #     path = "/health"
          #     port = 8080
          #   }
          #   initial_delay_seconds = 60
          #   period_seconds        = 10
          #   timeout_seconds       = 5
          #   failure_threshold     = 6
          # }
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
  
  depends_on = [kubernetes_namespace.dependencies]
}

resource "kubernetes_service_account" "scaling-webhook" {
  count = var.scaling_webhook.enabled ? 1 : 0
  
  metadata {
    name      = "scaling-webhook"
    namespace = "dependencies"
  }
  
  depends_on = [kubernetes_namespace.dependencies]
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
  
  depends_on = [
    kubernetes_namespace.dependencies,
    kubernetes_service_account.scaling-webhook
  ]
}

resource "kubernetes_config_map" "scaling-webhook-code" {
  count = var.scaling_webhook.enabled ? 1 : 0
  
  metadata {
    name      = "scaling-webhook-code"
    namespace = "dependencies"
  }
  
  depends_on = [kubernetes_namespace.dependencies]

  data = {
    "main.go" = <<EOF
package main

import (
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
    log.Printf("=== WEBHOOK CALLED: Method=%s, Path=%s ===", r.Method, r.URL.Path)
    
    if r.Method != http.MethodPost {
        log.Printf("ERROR: Invalid method %s", r.Method)
        http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
        return
    }

    var req ScaleRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        log.Printf("ERROR: Failed to decode JSON: %v", err)
        http.Error(w, "Invalid JSON", http.StatusBadRequest)
        return
    }

    log.Printf("=== SCALING REQUEST RECEIVED ===")
    log.Printf("Action: %s", req.Action)
    log.Printf("Target: %s", req.Target)
    log.Printf("NodesToAdd: %d", req.NodesToAdd)
    log.Printf("NodesToRemove: %d", req.NodesToRemove)
    log.Printf("ClusterType: %s", req.ClusterType)
    log.Printf("================================")

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
    nodeGroupName := req.Target + "-np"
    
    log.Printf("[EKS] Starting %s operation on cluster=%s, nodegroup=%s, region=%s", 
        req.Action, clusterName, nodeGroupName, region)
    
    var newSize int
    if req.Action == "scale_up" {
        log.Printf("[EKS] Getting current node count for %s", nodeGroupName)
        // Get current desired capacity and add nodes
        cmd := exec.Command("aws", "eks", "describe-nodegroup",
            "--cluster-name", clusterName,
            "--nodegroup-name", nodeGroupName,
            "--region", region,
            "--query", "nodegroup.scalingConfig.desiredSize",
            "--output", "text")
        
        output, err := cmd.Output()
        if err != nil {
            log.Printf("[EKS] Failed to get current size: %v", err)
            return err, ""
        }
        
        currentSize, err := strconv.Atoi(strings.TrimSpace(string(output)))
        if err != nil {
            log.Printf("[EKS] Failed to parse current size: %v", err)
            return err, ""
        }
        
        newSize = currentSize + req.NodesToAdd
        log.Printf("[EKS] Scaling UP %s: %d -> %d nodes (+%d)", nodeGroupName, currentSize, newSize, req.NodesToAdd)
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
    log.Printf("=== GKE SCALING FUNCTION CALLED ===")
    
    clusterName := os.Getenv("GKE_CLUSTER_NAME")
    if clusterName == "" {
        log.Printf("WARNING: GKE_CLUSTER_NAME not set, using default")
        clusterName = "pt-us-west1-a"
    }
    
    location := os.Getenv("GCP_REGION")
    isZone := false
    if location == "" {
        location = os.Getenv("GCP_ZONE")
        isZone = true
        if location == "" {
            location = "us-west1-a" // default zone
            isZone = true
        }
    }
    
    // Determine if location is a zone (has a dash followed by a letter)
    if strings.Count(location, "-") >= 2 && len(location) > 0 && location[len(location)-2] == '-' {
        isZone = true
    }
    
    nodePoolName := req.Target + "-np"
    locationFlag := "--zone"
    if !isZone {
        locationFlag = "--region"
    }
    
    log.Printf("[GKE] Starting %s operation on cluster=%s, nodepool=%s, location=%s (isZone=%v)", 
        req.Action, clusterName, nodePoolName, location, isZone)
    
    var newSize int
    if req.Action == "scale_up" {
        log.Printf("[GKE] Getting current node count for %s", nodePoolName)
        // Get current node count
        cmd := exec.Command("gcloud", "container", "node-pools", "describe", nodePoolName,
            "--cluster", clusterName,
            locationFlag, location,
            "--format", "value(initialNodeCount)")
            
        output, err := cmd.Output()
        if err != nil {
            log.Printf("[GKE] Failed to get current size: %v", err)
            return err, ""
        }
        
        currentSize, err := strconv.Atoi(strings.TrimSpace(string(output)))
        if err != nil {
            log.Printf("[GKE] Failed to parse current size: %v", err) 
            return err, ""
        }
        
        newSize = currentSize + req.NodesToAdd
        log.Printf("[GKE] Scaling UP %s: %d -> %d nodes (+%d)", nodePoolName, currentSize, newSize, req.NodesToAdd)
        
    } else if req.Action == "scale_down" {
        log.Printf("[GKE] Getting current node count for %s", nodePoolName)
        // Get current node count
        cmd := exec.Command("gcloud", "container", "node-pools", "describe", nodePoolName,
            "--cluster", clusterName,
            locationFlag, location,
            "--format", "value(initialNodeCount)")
            
        output, err := cmd.Output()
        if err != nil {
            log.Printf("[GKE] Failed to get current size: %v", err)
            return err, ""
        }
        
        currentSize, err := strconv.Atoi(strings.TrimSpace(string(output)))
        if err != nil {
            log.Printf("[GKE] Failed to parse current size: %v", err)
            return err, ""
        }
        
        newSize = currentSize - req.NodesToRemove
        if newSize < 1 {
            newSize = 1 // Minimum of 1 node
        }
        
        log.Printf("[GKE] Scaling DOWN %s: %d -> %d nodes (-%d)", nodePoolName, currentSize, newSize, req.NodesToRemove)
    }
    
    // Scale the node pool
    cmd := exec.Command("gcloud", "container", "clusters", "resize", clusterName,
        "--node-pool", nodePoolName,
        "--num-nodes", strconv.Itoa(newSize),
        locationFlag, location,
        "--quiet")
        
    cmdOutput, err := cmd.CombinedOutput()
    if err != nil {
        log.Printf("[GKE] Scale operation failed: %v, output: %s", err, string(cmdOutput))
        return err, ""
    }
    
    log.Printf("[GKE] Successfully initiated scaling operation: %s", string(cmdOutput))
    return nil, fmt.Sprintf("GKE node pool %s scaled to %d nodes", nodePoolName, newSize)
}
EOF
    
    "go.mod" = <<EOF
module scaling-webhook

go 1.21
EOF
  }
}