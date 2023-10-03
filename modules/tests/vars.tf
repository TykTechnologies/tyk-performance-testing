variable "tyk" {
  type = object({
    enabled   = bool
    version   = string
    analytics = bool
  })
}

variable "kong" {
  type = object({
    enabled   = bool
    version   = string
    analytics = bool
  })
}

variable "gravitee" {
  type = object({
    enabled   = bool
    version   = string
    analytics = bool
  })
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