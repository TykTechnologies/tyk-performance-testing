variable "kong_enabled" {
  type    = bool
  default = false
}

variable "kong_version" {
  type    = string
  default = "v5"
}

variable "kong_deployment_type" {
  type    = string
  default = "Deployment"
}

variable "kong_replica_count" {
  type    = number
  default = 1
}

variable "kong_external_traffic_policy" {
  type    = string
  default = "local"
}


variable "kong_resources_requests_cpu" {
  type    = string
  default = "0"
}

variable "kong_resources_requests_memory" {
  type    = string
  default = "0"
}

variable "kong_resources_limits_cpu" {
  type    = string
  default = "0"
}

variable "kong_resources_limits_memory" {
  type    = string
  default = "0"
}
