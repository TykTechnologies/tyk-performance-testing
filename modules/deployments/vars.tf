variable "enable_tyk" {
  type = bool
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
    tyk                = "tyk"
    tyk-resources      = "tyk-resources"
    kong               = "kong"
    kong-resources     = "kong-resources"
    gravitee           = "gravitee"
    gravitee-resources = "gravitee-resources"
  }
}
