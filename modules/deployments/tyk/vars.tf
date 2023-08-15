variable "namespace" {
  type    = string
  default = "tyk"
}

variable "label" {
  type = string
}

variable "resources-label" {
  type = string
}

variable "gateway_version" {
  type    = string
  default = "v5"
}

variable "enable_oTel" {
  type    = bool
  default = false
}

variable "oTel_sampling_ratio" {
  type    = string
  default = "0.5"
}