variable "tyk_enabled" {
  type        = bool
  default     = true
  description = "Enable Tyk services."
}

variable "kong_enabled" {
  type        = bool
  default     = false
  description = "Enable Kong services."
}

variable "gravitee_enabled" {
  type        = bool
  default     = false
  description = "Enable Gravitee services."
}
