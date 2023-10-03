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

variable "oTel" {
  type = object({
    enabled        = bool
    sampling_ratio = string
  })
}

variable "labels" {
  type = object({
    dependencies       = string
    tyk                = string
    tyk-upstream       = string
    tyk-tests          = string
    tyk-resources      = string
    kong               = string
    kong-upstream      = string
    kong-tests         = string
    kong-resources     = string
    gravitee           = string
    gravitee-upstream  = string
    gravitee-tests     = string
    gravitee-resources = string
  })
}
