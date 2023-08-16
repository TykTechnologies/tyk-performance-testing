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
    upstream           = string
    dependencies       = string
    k6                 = string
    tyk                = string
    tyk-resources      = string
    kong               = string
    kong-resources     = string
    gravitee           = string
    gravitee-resources = string
  })
  default = {
    upstream           = "upstream"
    dependencies       = "dependencies"
    k6                 = "k6"
    tyk                = "tyk"
    tyk-resources      = "tyk-resources"
    kong               = "kong"
    kong-resources     = "kong-resources"
    gravitee           = "gravitee"
    gravitee-resources = "gravitee-resources"
  }
}
