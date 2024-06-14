variable "tests" {
  type = object({
    timestamp = bool
    config = object({
      executor      = string
      ramping_steps = number
      duration      = number
      rate          = number
      virtual_users = number
      parallelism   = number

      auth = object({
        key_count = number
      })
    })
  })
}
