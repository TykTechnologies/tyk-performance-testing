variable "name" {
  type = string
}

variable "url" {
  type = string
}

variable "config" {
  type = object({
    executor      = string
    duration      = number
    rate          = number
    virtual_users = number
    parallelism   = number
  })
}
