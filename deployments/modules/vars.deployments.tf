variable "tyk" {
  type = object({
    enabled         = bool
    version         = string
    license         = string
    go_gc           = number
    go_max_procs    = number
    deployment_type = string
    replica_count   = number
    resources       = object({
      requests = object({
        cpu    = string
        memory = string
      })
      limits = object({
        cpu    = string
        memory = string
      })
    })
  })
}

variable "kong" {
  type = object({
    enabled         = bool
    version         = string
    deployment_type = string
    replica_count   = number
    resources       = object({
      requests = object({
        cpu    = string
        memory = string
      })
      limits = object({
        cpu    = string
        memory = string
      })
    })
  })
}

variable "gravitee" {
  type = object({
    enabled         = bool
    version         = string
    deployment_type = string
    replica_count   = number
    resources       = object({
      requests = object({
        cpu    = string
        memory = string
      })
      limits = object({
        cpu    = string
        memory = string
      })
    })
  })
}
