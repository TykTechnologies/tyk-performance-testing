variable "provider_nodes" {
  type = number
}

variable "enable_tyk" {
  type = bool
}

variable "enable_kong" {
  type = bool
}

variable "enable_gravitee" {
  type = bool
}

variable "worker_nodes" {
  type = map(number)
}
