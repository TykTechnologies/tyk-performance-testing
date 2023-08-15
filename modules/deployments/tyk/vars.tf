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
  type = string
}

variable "oTel" {
  type = object({
    enabled        = bool
    sampling_ratio = string
  })
}