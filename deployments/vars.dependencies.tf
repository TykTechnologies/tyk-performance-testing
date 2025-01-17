variable "grafana_service_type" {
  type        = string
  default     = "ClusterIP"
  description = "Grafana Dashboard service type. Set to 'LoadBalancer' type to be able to access Dashboard over the internet."
}

variable "upstream_enabled" {
  type        = bool
  default     = false
  description = "Enable Fortio upstream service for baseline testing."
}