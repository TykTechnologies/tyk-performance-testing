variable "namespace" {
  type    = string
  default = "kong"
}

variable "label" {
  type = string
}

variable "resources-label" {
  type = string
}

variable "gateway_version" {
  type = string
}

variable "analytics" {
  type = bool
}

variable "oTel" {
  type = object({
    enabled        = bool
    sampling_ratio = string
  })
}