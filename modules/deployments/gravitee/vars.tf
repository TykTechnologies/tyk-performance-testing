variable "namespace" {
  type    = string
  default = "gravitee"
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

variable "nginx_enabled" {
  type = bool
}
