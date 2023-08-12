variable "namespace" {
  type = string
}

variable "service_name" {
  type = string
}

variable "service_url" {
  type = string
}

variable "parallelism" {
  type    = number
  # Currently a bug in k6 implementation
  default = 1
}