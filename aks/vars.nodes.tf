variable "services_nodes_count" {
  type    = number
  default = 1
}

variable "resource_nodes_count" {
  type    = number
  default = 1
}

variable "dependencies_nodes_count" {
  type    = number
  default = 1
}

variable "tyk_enabled" {
  type    = bool
  default = true
}

variable "kong_enabled" {
  type    = bool
  default = false
}

variable "gravitee_enabled" {
  type    = bool
  default = false
}
