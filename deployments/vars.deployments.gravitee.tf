variable "gravitee_enabled" {
  type        = bool
  default     = false
  description = "Enable Gravitee services."
}

variable "gravitee_version" {
  type        = string
  default     = "4.3.4"
  description = "Gravitee Gateway version."
}

variable "gravitee_deployment_type" {
  type        = string
  default     = "Deployment"
  description = "Gravitee Gateway deployment type."
}

variable "gravitee_replica_count" {
  type        = number
  default     = 1
  description = "Gravitee Gateway replica count."
}

variable "gravitee_external_traffic_policy" {
  type        = string
  default     = "local"
  description = "Gravitee Gateway service external traffic policy. Set to 'local' when using 1 k8s node per gateway and 'cluster' when using multiple k8s nodes per gateway for optimal routing performance."
}

variable "gravitee_resources_requests_cpu" {
  type        = string
  default     = "0"
  description = "Gravitee Gateway CPU requests."
}

variable "gravitee_resources_requests_memory" {
  type        = string
  default     = "0"
  description = "Gravitee Gateway memory requests."
}

variable "gravitee_resources_limits_cpu" {
  type        = string
  default     = "0"
  description = "Gravitee Gateway CPU requests."
}

variable "gravitee_resources_limits_memory" {
  type        = string
  default     = "0"
  description = "Gravitee Gateway memory requests."
}
