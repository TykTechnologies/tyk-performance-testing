variable "tyk" {
  type = object({
    enabled         = bool
    version         = string
    license         = string
    go_gc           = number
    go_max_procs    = number
    deployment_type = string
  })
}

variable "kong" {
  type = object({
    enabled         = bool
    version         = string
    deployment_type = string
  })
}

variable "gravitee" {
  type = object({
    enabled         = bool
    version         = string
    deployment_type = string
    nginx_enabled   = bool
  })
}

variable "hpa" {
  type = object({
    enabled                 = bool
    max_replica_count       = number
    avg_cpu_util_percentage = number
  })
}

variable "replica_count" {
  type = number
}

variable "external_traffic_policy" {
  type = string
}

variable "resources" {
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
}
