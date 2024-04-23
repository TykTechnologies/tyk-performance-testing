variable "tests_parallelism" {
  type    = number
  default = 4
}

variable "tests_timestamp_enabled" {
  type    = bool
  default = true
}

variable "tests_httpbin_enabled" {
  type    = bool
  default = false
}
