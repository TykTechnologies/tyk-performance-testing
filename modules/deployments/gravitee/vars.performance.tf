variable "deployment_type" {
  type = string
}

variable "replica_count" {
  type = string
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
