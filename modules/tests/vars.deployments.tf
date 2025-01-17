variable "tyk" {
  type = object({
    enabled = bool
  })
}

variable "kong" {
  type = object({
    enabled = bool
  })
}

variable "gravitee" {
  type = object({
    enabled = bool
  })
}

variable "upstream" {
  type = object({
    enabled = bool
  })
}
