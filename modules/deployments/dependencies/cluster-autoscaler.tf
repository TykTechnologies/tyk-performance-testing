variable "cluster_type" {
  type    = string
  default = ""

  validation {
    condition     = contains(["eks", "aks", "gke"], var.cluster_type)
    error_message = "cluster_type must be one of: eks, aks, gke."
  }
}

variable "cluster_name" {
  type    = string
  default = ""

  validation {
    condition     = length(trim(var.cluster_name)) > 0
    error_message = "cluster_name must be a non-empty string."
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# Deploy Cluster Autoscaler only for EKS (GKE and AKS have it built-in)
resource "kubernetes_deployment" "cluster_autoscaler" {
  count = var.cluster_type == "eks" ? 1 : 0
  
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      app = "cluster-autoscaler"
    }
  }

  spec {
    replicas = 1
    
    selector {
      match_labels = {
        app = "cluster-autoscaler"
      }
    }
    
    template {
      metadata {
        labels = {
          app = "cluster-autoscaler"
        }
        annotations = {
          "cluster-autoscaler.kubernetes.io/safe-to-evict" = "false"
          "prometheus.io/scrape" = "true"
          "prometheus.io/port" = "8085"
        }
      }
      
      spec {
        service_account_name = kubernetes_service_account.cluster_autoscaler[0].metadata[0].name
        
        container {
          image = "registry.k8s.io/autoscaling/cluster-autoscaler:v1.28.2"
          name  = "cluster-autoscaler"
          
          command = [
            "./cluster-autoscaler",
            "--v=4",
            "--stderrthreshold=info",
            "--cloud-provider=aws",
            "--skip-nodes-with-local-storage=false",
            "--expander=least-waste",
            "--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/${var.cluster_name}",
            "--balance-similar-node-groups",
            "--skip-nodes-with-system-pods=false",
            "--scale-down-delay-after-add=10m",
            "--scale-down-unneeded-time=10m",
            "--max-node-provision-time=15m"
          ]
          
          env {
            name  = "AWS_REGION"
            value = var.aws_region
          }
          
          resources {
            limits = {
              cpu    = "100m"
              memory = "300Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "300Mi"
            }
          }
          
          liveness_probe {
            http_get {
              path = "/health-check"
              port = 8085
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }
        }
      }
    }
  }
}

# Service account for EKS cluster autoscaler
resource "kubernetes_service_account" "cluster_autoscaler" {
  count = var.cluster_type == "eks" ? 1 : 0
  
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      app = "cluster-autoscaler"
    }
  }
}

# ClusterRole for cluster autoscaler
resource "kubernetes_cluster_role" "cluster_autoscaler" {
  count = var.cluster_type == "eks" ? 1 : 0
  
  metadata {
    name = "cluster-autoscaler"
    labels = {
      app = "cluster-autoscaler"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["events", "endpoints"]
    verbs      = ["create", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods/eviction"]
    verbs      = ["create"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods/status"]
    verbs      = ["update"]
  }

  rule {
    api_groups = [""]
    resources  = ["endpoints"]
    resource_names = ["cluster-autoscaler"]
    verbs      = ["get", "update"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["watch", "list", "get", "update"]
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods", "services", "replicationcontrollers", "persistentvolumeclaims", "persistentvolumes"]
    verbs      = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["daemonsets", "deployments", "replicasets", "statefulsets"]
    verbs      = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
    verbs      = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
    verbs      = ["watch", "list"]
  }

  rule {
    api_groups = ["apps.openshift.io"]
    resources  = ["deploymentconfigs"]
    verbs      = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses", "csinodes", "csidrivers", "csistoragecapacities"]
    verbs      = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create"]
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resource_names = ["cluster-autoscaler"]
    resources  = ["leases"]
    verbs      = ["get", "update"]
  }
}

# ClusterRoleBinding for cluster autoscaler
resource "kubernetes_cluster_role_binding" "cluster_autoscaler" {
  count = var.cluster_type == "eks" ? 1 : 0
  
  metadata {
    name = "cluster-autoscaler"
    labels = {
      app = "cluster-autoscaler"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cluster_autoscaler[0].metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cluster_autoscaler[0].metadata[0].name
    namespace = "kube-system"
  }
}

# Role for cluster autoscaler in kube-system namespace
resource "kubernetes_role" "cluster_autoscaler" {
  count = var.cluster_type == "eks" ? 1 : 0
  
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      app = "cluster-autoscaler"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["create", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    resource_names = ["cluster-autoscaler-status", "cluster-autoscaler-priority-expander"]
    verbs      = ["delete", "get", "update", "watch"]
  }
}

# RoleBinding for cluster autoscaler in kube-system namespace
resource "kubernetes_role_binding" "cluster_autoscaler" {
  count = var.cluster_type == "eks" ? 1 : 0
  
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      app = "cluster-autoscaler"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.cluster_autoscaler[0].metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cluster_autoscaler[0].metadata[0].name
    namespace = "kube-system"
  }
}