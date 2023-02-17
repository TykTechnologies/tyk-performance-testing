variable "enable_tyk" {
  type    = bool
  default = true
}

variable "enable_kong" {
  type    = bool
  default = true
}

variable "enable_gravitee" {
  type    = bool
  default = true
}

variable "node-labels" {
  type = object({
    dependencies       = string
    tyk                = string
    tyk-resources      = string
    kong               = string
    kong-resources     = string
    gravitee           = string
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