variable "tyk_enabled" {
  type        = bool
  default     = true
  description = "Enable Tyk services."
}

variable "tyk_version" {
  type        = string
  default     = "v5.4"
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
