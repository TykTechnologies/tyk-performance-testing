variable "namespace" {
  type = string
}

variable "auth" {
  type = object({
    enabled = bool
  })
}