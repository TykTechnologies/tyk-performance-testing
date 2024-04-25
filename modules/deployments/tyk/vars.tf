variable "namespace" {
  type     = string
  default  = "tyk"
  required = true
}

variable "license" {
  type     = string
  required = true
}

variable "label" {
  type     = string
  required = true
}

variable "resources-label" {
  type     = string
  required = true
}

variable "gateway_version" {
  type     = string
  required = true
}
