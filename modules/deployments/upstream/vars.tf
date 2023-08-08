variable "namespace" {
  type    = string
  default = "upstream"
}

variable "label" {
  type = string
}

variable "enable_httpbin" {
  type    = bool
  default = true
}

variable "enable_timestamp" {
  type    = bool
  default = true
}
