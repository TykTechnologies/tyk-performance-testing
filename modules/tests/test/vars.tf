variable "name" {
  type = string
}

variable "url" {
  type = string
}

variable "config" {
  type = object({
    fortio_options = string
    executor       = string
    ramping_steps  = number
    duration       = number
    rate           = number
    virtual_users  = number
    parallelism    = number

    auth = object({
      key_count = number
    })
  })
}
