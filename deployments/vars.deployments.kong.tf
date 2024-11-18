variable "kong_enabled" {
  type        = bool
  default     = false
  description = "Enable Kong services."
}

variable "kong_version" {
  type        = string
  default     = "3.8"
  description = "Kong Gateway version."
}

variable "kong_deployment_type" {
  type        = string
  default     = "Deployment"
  description = "Kong Gateway deployment type."
}

variable "kong_service_type" {
  type        = string
  default     = "ClusterIP"
  description = "Kong Gateway service type."
}
