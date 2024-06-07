variable "analytics_database_enabled" {
  type        = bool
  default     = false
  description = "Enables metrics collection on gateway services and stores them in gateways default database."
}

variable "analytics_prometheus_enabled" {
  type        = bool
  default     = false
  description = "Enables metrics collection on gateway services and aggregates them on an endpoint for prometheus to scrape."
}

variable "auth_enabled" {
  type        = bool
  default     = false
  description = "Enables authorization on gateway APIs."
}

variable "quota_enabled" {
  type        = bool
  default     = false
  description = "Enables quota management on gateway APIs."
}

variable "quota_rate" {
  type        = number
  default     = 999999
  description = "Quota management rate on gateway APIs."
}

variable "quota_per" {
  type        = number
  default     = 3600
  description = "Quota management reset interval in seconds."
}

variable "rate_limit_enabled" {
  type        = bool
  default     = false
  description = "Enables rate limiting on gateway APIs."
}

variable "rate_limit_rate" {
  type        = number
  default     = 999999
  description = "Rate Limit rate on gateway APIs."
}

variable "rate_limit_per" {
  type        = number
  default     = 60
  description = "Rate Limit reset interval in seconds."
}

variable "open_telemetry_enabled" {
  type        = bool
  default     = false
  description = "Enable Open Telemetry and trace collection on gateway services."
}

variable "open_telemetry_sampling_ratio" {
  type        = string
  default     = "0.5"
  description = "Open Telemetry sampling ration 0 to 1.0 range."
}
