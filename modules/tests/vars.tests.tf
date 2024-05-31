variable "tests" {
  type = object({
    timestamp     = bool
    httpbin       = bool
    config = object({
      executor      = string
      ramping_steps = number
      duration      = number
      rate          = number
      virtual_users = number
      parallelism   = number

      auth = object({
        enabled   = bool
        key_count = number
      })
    })
  })
}
