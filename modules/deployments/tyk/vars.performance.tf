variable "deployment_type" {
  type = string
}

variable "service_type" {
  type = string
}

variable "replica_count" {
  type = string
}

variable "hpa" {
  type = object({
    enabled                 = bool
    max_replica_count       = number
    avg_cpu_util_percentage = number
  })
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

variable "go_gc" {
  type = string
}

variable "go_max_procs" {
  type = string
}

variable "profiler" {
  type = object({
    enabled = bool
  })
}
