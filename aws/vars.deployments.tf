variable "service_nodes" {
  type    = number
  default = 1
}

variable "resource_nodes" {
  type    = number
  default = 1
}

variable "tyk" {
  type = object({
    enabled   = bool
    version   = string
    analytics = bool
  })
  default = {
    enabled   = true
    version   = "v5"
    analytics = false
  }
}

variable "kong" {
  type = object({
    enabled   = bool
    version   = string
    analytics = bool
  })
  default = {
    enabled   = true
    version   = "v5"
    analytics = false
  }
}

variable "gravitee" {
  type = object({
    enabled   = bool
    version   = string
    analytics = bool
  })
  default = {
    enabled   = true
    version   = "v5"
    analytics = false
  }
}
