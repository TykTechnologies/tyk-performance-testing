variable "service_nodes" {
  type    = number
  default = 1
}

variable "resource_nodes" {
  type    = number
  default = 1
}

variable "tyk" {
  type = object({
    enabled = bool
    version = string
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
    version = "v5"
  }
}
