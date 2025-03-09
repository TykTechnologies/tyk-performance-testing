variable "traefik_enabled" {
  type        = bool
  default     = false
  description = "Enable Traefik services."
}

variable "traefik_version" {
  type        = string
  default     = "3.8"
  description = "Traefik Gateway version."
}

variable "traefik_deployment_type" {
  type        = string
  default     = "Deployment"
  description = "Traefik Gateway deployment type."
}

variable "traefik_service_type" {
  type        = string
  default     = "ClusterIP"
  description = "Traefik Gateway service type."
}
