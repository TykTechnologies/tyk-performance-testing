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
    type    = string
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

variable "header_injection" {
  type = object({
    req = object({
      enabled = bool
    })
    res = object({
      enabled = bool
    })
  })
}
