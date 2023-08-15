variable "service_nodes" {
  type = number
}

variable "resource_nodes" {
  type = number
}

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