variable "grafana_service_type" {
  type        = string
  default     = "ClusterIP"
  description = "Grafana Dashboard service type. Set to 'LoadBalancer' type to be able to access Dashboard over the internet."
}

variable "upstream_enabled" {
  type        = bool
  default     = false
  description = "Enable Fortio upstream service for baseline testing."
}

variable "scaling_webhook_enabled" {
  type        = bool
  default     = false
  description = "Enable scaling webhook for dynamic node scaling during tests (deprecated - use native cluster autoscaler instead)."
}

variable "cluster_type" {
  type        = string
  default     = ""
  description = "Type of Kubernetes cluster (eks, aks, gke)."

  validation {
    condition     = contains(["eks", "aks", "gke"], var.cluster_type)
    error_message = "cluster_type must be one of: eks, aks, gke. Provide it via -var or TF_VAR_cluster_type."
  }
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "Name of the Kubernetes cluster."

  validation {
    condition     = length(trim(var.cluster_name)) > 0
    error_message = "cluster_name must be a non-empty string (e.g., 'performance-testing')."
  }
}

variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region for EKS operations."
}

variable "gcp_region" {
  type        = string
  default     = "us-central1-a"
  description = "GCP region/zone for GKE operations."
}