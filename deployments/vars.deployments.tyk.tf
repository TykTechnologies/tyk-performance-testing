variable "tyk_enabled" {
  type    = bool
  default = true
}

variable "tyk_version" {
  type    = string
  default = "v5.3.0"
}

variable "tyk_license" {
  type = string
}

variable "tyk_deployment_type" {
  type    = string
  default = "Deployment"
}

variable "tyk_replica_count" {
  type    = number
  default = 1
}

variable "tyk_go_gc" {
  type    = number
  default = 1600
}

variable "tyk_go_max_procs" {
  type    = number
  default = 8
}

variable "tyk_resources_requests_cpu" {
  type    = string
  default = "0"
}

variable "tyk_resources_requests_memory" {
  type    = string
  default = "0"
}

variable "tyk_resources_limits_cpu" {
  type    = string
  default = "0"
}

variable "tyk_resources_limits_memory" {
  type    = string
  default = "0"
}
