variable "labels" {
  type = object({
    dependencies       = string
    tyk                = string
    tyk-upstream       = string
    tyk-tests          = string
    tyk-resources      = string
    kong               = string
    kong-upstream      = string
    kong-tests         = string
    kong-resources     = string
    gravitee           = string
    gravitee-upstream  = string
    gravitee-tests     = string
    gravitee-resources = string
    traefik            = string
    traefik-upstream   = string
    traefik-tests      = string
    traefik-resources  = string
    upstream           = string
    upstream-tests     = string
  })
}

variable "cluster_type" {
  type        = string
  default     = ""
  description = "Type of Kubernetes cluster (eks, aks, gke) - must be explicitly set"

  validation {
    condition     = contains(["eks", "aks", "gke"], var.cluster_type)
    error_message = "cluster_type must be one of: eks, aks, gke. Provide it via -var or TF_VAR_cluster_type."
  }
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "Name of the Kubernetes cluster"

  validation {
    condition     = length(trimspace(var.cluster_name)) > 0
    error_message = "cluster_name must be a non-empty string (e.g., 'performance-testing')."
  }
}



variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for EKS cluster autoscaler"
}
