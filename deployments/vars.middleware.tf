variable "analytics_enabled" {
  type    = bool
  default = false
}

variable "auth_enabled" {
  type    = bool
  default = false
}

variable "quota_enabled" {
  type    = bool
  default = false
}

variable "rate_limit_enabled" {
  type    = bool
  default = false
}

variable "open_telemetry_enabled" {
  type    = bool
  default = false
}

variable "open_telemetry_sampling_ratio" {
  type    = string
  default = "0.5"
}
