variable "gravitee_enabled" {
  type    = bool
  default = false
}

variable "gravitee_version" {
  type    = string
  default = "4.1"
}

variable "gravitee_deployment_type" {
  type    = string
  default = "Deployment"
}

variable "gravitee_replica_count" {
  type    = number
  default = 1
}

variable "gravitee_resources_requests_cpu" {
  type    = string
  default = "0"
}

variable "gravitee_resources_requests_memory" {
  type    = string
  default = "0"
}

variable "gravitee_resources_limits_cpu" {
  type    = string
  default = "0"
}

variable "gravitee_resources_limits_memory" {
  type    = string
  default = "0"
}
