variable "tests" {
  type = object({
    parallelism = number
    timestamp   = bool
    httpbin     = bool
    duration    = number
  })
}
