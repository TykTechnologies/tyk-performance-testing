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
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "Name of the Kubernetes cluster."
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