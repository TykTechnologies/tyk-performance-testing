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
  default     = true
  description = "Enable scaling webhook for dynamic node scaling during tests."
}

variable "cluster_type" {
  type        = string
  default     = "eks"
  description = "Type of Kubernetes cluster (eks, aks, gke)."
}

variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region for EKS operations."
}