variable "tests" {
  type = object({
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
}
