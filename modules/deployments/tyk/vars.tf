variable "namespace" {
  type    = string
  default = "tyk"
}

variable "license" {
  type = string
}

variable "label" {
  type = string
}

variable "resources-label" {
  type = string
}

variable "gateway_version" {
  type = string
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
