variable "tests" {
  type = object({
    timestamp = bool
    httpbin   = bool
  })
  default = {
    timestamp = true
    httpbin   = true
  }
}