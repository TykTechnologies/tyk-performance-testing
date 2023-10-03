variable "name" {
  type = string
}

variable "url" {
  type = string
}

variable "oTel" {
  type = object({
    enabled        = bool
    sampling_ratio = string
  })
}

variable "parallelism" {
  type = number
}
