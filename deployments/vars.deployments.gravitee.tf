variable "gravitee_enabled" {
  type        = bool
  default     = false
  description = "Enable Gravitee services."
}

variable "gravitee_version" {
  type        = string
  default     = "4.3.5"
  description = "Gravitee Gateway version."
}

variable "gravitee_deployment_type" {
  type        = string
  default     = "Deployment"
  description = "Gravitee Gateway deployment type."
}
