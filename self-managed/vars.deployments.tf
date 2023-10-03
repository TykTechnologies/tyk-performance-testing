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
    version   = "4.1"
    analytics = false
  }
}

variable "node-labels" {
  type = object({
    dependencies       = string
    tyk                = string
    tyk-upstream       = string
    tyk-tests          = string
    tyk-resources      = string
    kong               = string
    kong-upstream      = string
    kong-tests         = string
    kong-resources     = string
    gravitee           = string
    gravitee-upstream  = string
    gravitee-tests     = string
    gravitee-resources = string
  })
}

variable "kubernetes" {
  type = object({
    host                   = string
    username               = string
    password               = string
    token                  = string
    client_key             = string
    client_certificate     = string
    cluster_ca_certificate = string
    config_path            = string
    config_context         = string
  })
}