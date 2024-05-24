variable "tests" {
  type = object({
    timestamp     = bool
    httpbin       = bool
    config = object({
      executor      = string
      duration      = number
      rate          = number
      virtual_users = number
      parallelism   = number
    })
  })
}
