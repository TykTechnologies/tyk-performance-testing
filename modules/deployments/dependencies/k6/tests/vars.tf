variable "namespace" {
  type = string
}

variable "service" {
  type    = object({
    route_count = number
    app_count   = number
    host_count  = number
  })
  default = {
    route_count = 1
    app_count   = 1
    host_count  = 1
  }
}
