variable "tyk" {
  type = object({
    enabled   = bool
    version   = string
  })
  default = {
    enabled = true
    version = "v5"
  }
}

variable "kong" {
  type = object({
    enabled = bool
    version = string
  })
  default = {
    enabled = true
    version = "v5"
  }
}

variable "gravitee" {
  type = object({
    enabled = bool
    version = string
  })
  default = {
    enabled = true
    version = "4.1"
  }
}
