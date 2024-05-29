variable "hpa_enabled" {
  type        = bool
  default     = true
  description = "Option to enable gateways Horizontal Pod Autoscaler."
}

variable "hpa_max_replica_count" {
  type        = number
  default     = 4
  description = "Gateways Horizontal Pod Autoscaler max replica count."
}

variable "hpa_avg_cpu_util_percentage" {
  type        = number
  default     = 80
  description = "Gateways Horizontal Pod Autoscaler average CPU utilization percentage for scaling."
}

variable "replica_count" {
  type        = number
  default     = 1
  description = "Gateway replica count."
}

variable "external_traffic_policy" {
  type        = string
  default     = "local"
  description = "Gateway service external traffic policy. Set to 'local' when using 1 k8s node per gateway and 'cluster' when using multiple k8s nodes per gateway for optimal routing performance."
}

variable "resources_requests_cpu" {
  type        = string
  default     = "0"
  description = "Gateway CPU requests."
}

variable "resources_requests_memory" {
  type        = string
  default     = "0"
  description = "Gateway memory requests."
}

variable "resources_limits_cpu" {
  type        = string
  default     = "0"
  description = "Gateway CPU requests."
}

variable "resources_limits_memory" {
  type        = string
  default     = "0"
  description = "Gateway memory requests."
}
