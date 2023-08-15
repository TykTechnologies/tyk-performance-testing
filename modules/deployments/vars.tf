variable "enable_tyk" {
  type = bool
}

variable "tyk_version" {
  type    = string
  default = "v5"
}

variable "tyk_enable_oTel" {
  type    = bool
  default = false
}

variable "tyk_oTel_sampling_ratio" {
  type    = string
  default = "0.5"
}

variable "enable_kong" {
  type = bool
}

variable "enable_gravitee" {
  type = bool
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
