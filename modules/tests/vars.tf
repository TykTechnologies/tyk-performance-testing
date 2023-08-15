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
  default = 4
}

variable "oTel" {
  type = object({
    enabled        = bool
    sampling_ratio = string
  })
}

variable "tests" {
  type = object({
    timestamp = bool
    httpbin   = bool
  })
}