variable "namespace" {
  type = string
}

variable "service_name" {
  type = string
}

variable "service_url" {
  type = string
}

variable "parallelism" {
  type = number
}

variable "oTel" {
  type = object({
    enabled        = bool
    sampling_ratio = string
  })
}
