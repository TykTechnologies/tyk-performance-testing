variable "gravitee_enabled" {
  type        = bool
  default     = false
  description = "Enable Gravitee services."
}

variable "gravitee_version" {
  type        = string
  default     = "4.5"
  description = "Gravitee Gateway version."
}

variable "gravitee_deployment_type" {
  type        = string
  default     = "Deployment"
  description = "Gravitee Gateway deployment type."
}

variable "gravitee_nginx_enabled" {
  type        = bool
  default     = false
  description = "Gravitee Nginx controller for exposing UI and Portal."
}
