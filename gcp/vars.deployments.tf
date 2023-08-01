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
