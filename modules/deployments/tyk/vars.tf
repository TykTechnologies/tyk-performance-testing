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
