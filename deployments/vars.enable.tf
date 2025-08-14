variable "enable_tyk" {
  type        = bool
  default     = false
  description = "Enable Tyk gateway (propagated to modules/deployments). Must be a plan-time boolean; do not derive from resources/data."
  nullable    = false
}

variable "enable_kong" {
  type        = bool
  default     = false
  description = "Enable Kong gateway (propagated to modules/deployments). Must be a plan-time boolean; do not derive from resources/data."
  nullable    = false
}

variable "enable_gravitee" {
  type        = bool
  default     = false
  description = "Enable Gravitee gateway (propagated to modules/deployments). Must be a plan-time boolean; do not derive from resources/data."
  nullable    = false
}

variable "enable_traefik" {
  type        = bool
  default     = false
  description = "Enable Traefik gateway (propagated to modules/deployments). Must be a plan-time boolean; do not derive from resources/data."
  nullable    = false
}

# Optional: if you want to drive the shared upstream from root too.
variable "enable_upstream" {
  type        = bool
  default     = false
  description = "Enable shared upstream (Fortio) baseline services (propagated to modules/deployments). Prefer passing this from the existing upstream_enabled variable."
  nullable    = false
}

variable "use_config_maps_for_apis" {
  type        = bool
  default     = false
  nullable    = false
  description = "Use ConfigMaps for API definitions (plumbed to module.deployments -> module.tyk). Having a default prevents CI prompts."
}