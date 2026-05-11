variable "hpa_enabled" {
  type        = bool
  default     = false
  description = "Option to enable gateways Horizontal Pod Autoscaler. Defaults to false because HPA muddles memory-leak detection: when pods get full it spins up new ones with empty caches and routes traffic to them, and when load drops it terminates pods (freeing leaked memory). For clean leak observation prefer a fixed replica_count."
}

variable "hpa_max_replica_count" {
  type        = number
  default     = 12
  description = "Gateways Horizontal Pod Autoscaler max replica count."
}

variable "hpa_avg_cpu_util_percentage" {
  type        = number
  default     = 70
  description = "Gateways Horizontal Pod Autoscaler average CPU utilization percentage for scaling."
}

variable "replica_count" {
  type        = number
  default     = 6
  description = "Gateway replica count. Defaults to 6 to give a constant-arrival-rate run at ~20k rps enough capacity without HPA in the loop (each pod can comfortably do ~3-4k rps on the default request_cpu=1, limit_cpu=2 resource shape). Lower this only if you also lower tests_rate."
}

variable "external_traffic_policy" {
  type        = string
  default     = "Local"
  description = "Gateway service external traffic policy. Set to 'local' when using 1 k8s node per gateway and 'cluster' when using multiple k8s nodes per gateway for optimal routing performance."
}

variable "resources_requests_cpu" {
  type        = string
  default     = "500m"
  description = "Gateway CPU requests."
}

variable "resources_requests_memory" {
  type        = string
  default     = "512Mi"
  description = "Gateway memory requests."
}

variable "resources_limits_cpu" {
  type        = string
  default     = "2000m"
  description = "Gateway CPU limits."
}

variable "resources_limits_memory" {
  type        = string
  default     = "2Gi"
  description = "Gateway memory limits."
}

variable "use_config_maps_for_apis" {
  type        = bool
  default     = true
  nullable    = false
  description = "Use ConfigMaps for API definitions (plumbed to module.deployments -> module.tyk). Having a default prevents CI prompts."
}
