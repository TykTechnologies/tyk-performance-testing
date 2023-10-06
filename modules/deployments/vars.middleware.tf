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

variable "oTel" {
  type = object({
    enabled        = bool
    sampling_ratio = string
  })
}

variable "quota" {
  type = object({
    enabled = bool
  })
}

variable "rateLimiting" {
  type = object({
    enabled = bool
  })
}
