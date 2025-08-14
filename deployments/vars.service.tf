variable "service_route_count" {
  type        = number
  default     = 10
  description = "Service route count - number of APIs."
}

variable "service_app_count" {
  type        = number
  default     = 10
  description = "Service app count - number of security policies/API product/Apps."
}

variable "service_host_count" {
  type        = number
  default     = 1
  description = "Service host count - number of k8s services to provision."
}
