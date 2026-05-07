variable "tests" {
  type = object({
    fortio_options = string
    executor       = string
    ramping_steps  = number
    duration       = number
    rate           = number
    virtual_users  = number
    parallelism    = number
    segment        = optional(number, 1)
    total_segments = optional(number, 1)

    auth = object({
      key_count        = number
      random_selection = optional(bool, false)
      rolling          = optional(bool, false)
    })
  })
}
