variable "tests" {
  type = object({
    timestamp = bool
    httpbin   = bool
  })
}