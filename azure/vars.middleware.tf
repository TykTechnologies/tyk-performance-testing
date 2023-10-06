variable "analytics" {
  type = object({
    enabled = bool
  })
  default = {
    enabled = false
  }
}

variable "auth" {
  type = object({
    enabled = bool
  })
  default = {
    enabled = false
  }
}

variable "oTel" {
  type = object({
    enabled        = bool
    sampling_ratio = string
  })
  default = {
    enabled        = false
    sampling_ratio = "0.5"
  }
}

variable "quota" {
  type = object({
    enabled = bool
  })
  default = {
    enabled = false
  }
}

variable "rateLimiting" {
  type = object({
    enabled = bool
  })
  default = {
    enabled = false
  }
}
