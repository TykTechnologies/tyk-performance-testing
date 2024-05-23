variable "kong_enabled" {
  type        = bool
  default     = false
  description = "Enable Kong services."
}

variable "kong_version" {
  type        = string
  default     = "v5"
  description = "Kong Gateway version."
}

variable "kong_deployment_type" {
  type        = string
  default     = "Deployment"
  description = "Kong Gateway deployment type."
}

variable "kong_replica_count" {
  type        = number
  default     = 1
  description = "Kong Gateway replica count."
}

variable "kong_external_traffic_policy" {
  type        = string
  default     = "local"
  description = "Kong Gateway service external traffic policy. Set to 'local' when using 1 k8s node per gateway and 'cluster' when using multiple k8s nodes per gateway for optimal routing performance."
}

variable "kong_resources_requests_cpu" {
  type        = string
  default     = "0"
  description = "Kong Gateway CPU requests."
}

variable "kong_resources_requests_memory" {
  type        = string
  default     = "0"
  description = "Kong Gateway memory requests."
}

variable "kong_resources_limits_cpu" {
  type        = string
  default     = "0"
  description = "Kong Gateway CPU requests."
}

variable "kong_resources_limits_memory" {
  type        = string
  default     = "0"
  description = "Kong Gateway memory requests."
}
