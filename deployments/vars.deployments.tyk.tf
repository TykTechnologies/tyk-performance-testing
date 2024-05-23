variable "tyk_enabled" {
  type        = bool
  default     = true
  description = "Enable Tyk services."
}

variable "tyk_version" {
  type        = string
  default     = "v5.3.1"
  description = "Tyk Gateway version."
}

variable "tyk_license" {
  type        = string
  description = "Tyk self-managed license."
}

variable "tyk_deployment_type" {
  type        = string
  default     = "Deployment"
  description = "Tyk Gateway deployment type."
}

variable "tyk_replica_count" {
  type        = number
  default     = 1
  description = "Tyk Gateway replica count."
}

variable "tyk_external_traffic_policy" {
  type        = string
  default     = "local"
  description = "Tyk Gateway service external traffic policy. Set to 'local' when using 1 k8s node per gateway and 'cluster' when using multiple k8s nodes per gateway for optimal routing performance."
}

variable "tyk_go_gc" {
  type        = number
  default     = 1600
  description = "Target percentage for garbage collection execution in Go."
}

variable "tyk_go_max_procs" {
  type        = number
  default     = 8
  description = "Limits the number of operating system threads that can execute user-level Go code simultaneously. Matching the value to threads * cpu limit allows for optimal performance."
}

variable "tyk_resources_requests_cpu" {
  type        = string
  default     = "0"
  description = "Tyk Gateway CPU requests."
}

variable "tyk_resources_requests_memory" {
  type        = string
  default     = "0"
  description = "Tyk Gateway memory requests."
}

variable "tyk_resources_limits_cpu" {
  type        = string
  default     = "0"
  description = "Tyk Gateway CPU requests."
}

variable "tyk_resources_limits_memory" {
  type        = string
  default     = "0"
  description = "Tyk Gateway memory requests."
}
