variable "tyk" {
  type = object({
    enabled         = bool
    version         = string
    deployment_type = string
    replica_count   = number
    go_gc           = number
    go_max_procs    = number
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
  default = {
    enabled         = true
    version         = "v5.2.2"
    deployment_type = "Deployment"
    replica_count   = 1
    go_gc           = 1600
    go_max_procs    = 8
    resources       = {
      requests = {
        cpu    = 0
        memory = 0
      }
      limits = {
        cpu    = 0
        memory = 0
      }
    }
  }
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
  default = {
    enabled         = true
    version         = "v5"
    deployment_type = "Deployment"
    replica_count   = 1
    resources       = {
      requests = {
        cpu    = 0
        memory = 0
      }
      limits = {
        cpu    = 0
        memory = 0
      }
    }
  }
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
  default = {
    enabled         = true
    version         = "4.1"
    deployment_type = "Deployment"
    replica_count   = 1
    resources       = {
      requests = {
        cpu    = 0
        memory = 0
      }
      limits = {
        cpu    = 0
        memory = 0
      }
    }
  }
}
