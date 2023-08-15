variable "service_nodes" {
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

variable "tyk_version" {
  type    = string
  default = "v5"
}

variable "tyk_enable_oTel" {
  type    = bool
  default = false
}

variable "tyk_oTel_sampling_ratio" {
  type    = string
  default = "0.5"
}

variable "enable_kong" {
  type    = bool
  default = true
}

variable "enable_gravitee" {
  type    = bool
  default = true
}
