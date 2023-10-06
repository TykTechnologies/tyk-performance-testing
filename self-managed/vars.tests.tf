variable "tests" {
  type = object({
    parallelism = number
    timestamp   = bool
    httpbin     = bool
  })
  default = {
    parallelism = 4
    timestamp   = true
    httpbin     = true
  }
}
