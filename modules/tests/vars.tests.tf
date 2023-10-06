variable "parallelism" {
  type    = number
  default = 4
}

variable "tests" {
  type = object({
    timestamp = bool
    httpbin   = bool
  })
}