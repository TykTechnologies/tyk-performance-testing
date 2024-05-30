variable "analytics" {
  type = object({
    database = object({
      enabled = bool
    })
    prometheus = object({
      enabled = bool
    })
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
    rate    = number
    per     = number
  })
}

variable "rate_limit" {
  type = object({
    enabled = bool
    rate    = number
    per     = number
  })
}

variable "open_telemetry" {
  type = object({
    enabled        = bool
    sampling_ratio = string
  })
}
