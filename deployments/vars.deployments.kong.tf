variable "kong_enabled" {
  type        = bool
  default     = false
  description = "Enable Kong services."
}

variable "kong_version" {
  type        = string
  default     = "3.6"
  description = "Kong Gateway version."
}

variable "kong_deployment_type" {
  type        = string
  default     = "Deployment"
  description = "Kong Gateway deployment type."
}
