variable "tests_timestamp_enabled" {
  type    = bool
  default = true
}

variable "tests_httpbin_enabled" {
  type    = bool
  default = false
}

variable "tests_config_executor" {
  type    = string
  default = "constant-arrival-rate"
}

variable "tests_config_ramping_steps" {
  type    = number
  default = 10
}

variable "tests_config_duration" {
  type    = number
  default = 15
}

variable "tests_config_rate" {
  type    = number
  default = 20000
}

variable "tests_config_virtual_users" {
  type    = number
  default = 50
}

variable "tests_config_parallelism" {
  type    = number
  default = 4
}
