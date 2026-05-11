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
  default     = true
  description = "Enables authorization on gateway APIs."
}

variable "auth_type" {
  type        = string
  default     = "authToken"
  description = "Authorization type on gateway APIs. authToken, JWT-RSA or JWT-HMAC. Defaults to authToken (the repo's historical default). The Full Performance Test workflow exposes a 'use_jwt' checkbox that flips this to JWT-HMAC when set, which also enables rolling JWT signing in k6 setup() for high-cardinality leak repros."
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
  default     = true
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

variable "open_telemetry_metrics_enabled" {
  type        = bool
  default     = true
  description = "Enable OpenTelemetry metrics export on gateway services. Defaults to true so the OTel collector forwards Tyk gateway metrics to Prometheus, making memory-leak / GC-pressure regressions (e.g. Tyk PR 8180) visible in the same Grafana that hosts k6 traffic metrics."
}

variable "open_telemetry_runtime_metrics" {
  type        = bool
  default     = true
  description = "Enable OpenTelemetry runtime metrics (Go runtime stats: heap_inuse, heap_objects, goroutines, gc_duration, ...) on gateway services. Defaults to true; without these we cannot tell a memory leak from increased load."
}

variable "open_telemetry_metrics_api_metrics" {
  type        = string
  default     = ""
  description = "JSON array of custom API metric definitions for OpenTelemetry metrics."
}

variable "header_injection_req_enabled" {
  type        = bool
  default     = false
  description = "Gateway will inject an X-API-REQ header with Foo value."
}

variable "header_injection_res_enabled" {
  type        = bool
  default     = false
  description = "Gateway will inject an X-API-RES header with Bar value."
}
