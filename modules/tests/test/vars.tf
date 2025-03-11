variable "name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "service_port" {
  type = number
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
