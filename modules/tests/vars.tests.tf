variable "tests" {
  type = object({
    parallelism   = number
    timestamp     = bool
    httpbin       = bool
    duration      = number
    virtual_users = number
  })
}
