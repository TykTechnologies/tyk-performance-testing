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

variable "enable_tyk" {
  type = bool
}

variable "enable_kong" {
  type = bool
}

variable "enable_gravitee" {
  type = bool
}
