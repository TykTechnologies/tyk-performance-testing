variable "analytics" {
  type = object({
    enabled = bool
  })
}

variable "auth" {
  type = object({
    enabled = bool
  })
}

variable "quota" {
  type = object({
    enabled = bool
  })
}

variable "rate_limit" {
  type = object({
    enabled = bool
  })
}

variable "open_telemetry" {
  type = object({
    enabled        = bool
    sampling_ratio = string
  })
}
