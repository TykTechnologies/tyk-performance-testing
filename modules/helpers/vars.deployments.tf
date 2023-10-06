variable "tyk" {
  type = object({
    enabled = bool
    version = string
  })
}

variable "kong" {
  type = object({
    enabled = bool
    version = string
  })
}

variable "gravitee" {
  type = object({
    enabled = bool
    version = string
  })
}
