variable "labels" {
  type = object({
    dependencies       = string
    tyk                = string
    tyk-upstream       = string
    tyk-tests          = string
    tyk-resources      = string
    kong               = string
    kong-upstream      = string
    kong-tests         = string
    kong-resources     = string
    gravitee           = string
    gravitee-upstream  = string
    gravitee-tests     = string
    gravitee-resources = string
    traefik            = string
    traefik-upstream   = string
    traefik-tests      = string
    traefik-resources  = string
    upstream           = string
    upstream-tests     = string
  })
}

variable "use_config_maps_for_apis" {
  type        = bool
  description = "If true, provide API definitions to the gateway via ConfigMaps instead of the default mechanism."
  default     = true
  nullable    = false
}

variable "dockerhub_username" {
  type        = string
  description = "Docker Hub username for authenticated image pulls"
  default     = ""
}

variable "dockerhub_password" {
  type        = string
  description = "Docker Hub password for authenticated image pulls"
  sensitive   = true
  default     = ""
}
