variable "provider_nodes" {
  type    = number
  default = 1
}

variable "resource_nodes" {
  type    = number
  default = 1
}

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

variable "worker_nodes" {
  type    = map(number)
  default = {
    upstream           = 1
    dependencies       = 1
    tyk-resources      = 1
    kong-resources     = 1
    gravitee-resources = 1
  }
}