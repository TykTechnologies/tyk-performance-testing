variable "tests_fortio_options" {
  type        = string
  default     = "size=20"
  description = "Set the parameters for the request to fortio-server. Read more at https://github.com/fortio/fortio?tab=readme-ov-file#server-urls-and-features"
}

variable "tests_executor" {
  type        = string
  default     = "constant-arrival-rate"
  description = "Choose the executor for the test. Options are: 'constant-vus', 'ramping-vus', 'constant-arrival-rate', 'ramping-arrival-rate', 'externally-controlled'."
}

variable "tests_auth_key_count" {
  type        = number
  default     = 100
  description = "Number of Authentication Tokens used for the test per test worker (tests_parallelism)."
}

variable "tests_ramping_steps" {
  type        = number
  default     = 10
  description = "Number of ramping steps for the test, applies for 'ramping-vus' and 'ramping-arrival-rate' executors."
}

variable "tests_duration" {
  type        = number
  default     = 15
  description = "Test duration in minutes."
}

variable "tests_rate" {
  type        = number
  default     = 20000
  description = "Test RPS, applies for 'constant-arrival-rate' and 'ramping-arrival-rate' executors."
}

variable "tests_virtual_users" {
  type        = number
  default     = 50
  description = "Number of virtual users to be used for the test."
}

variable "tests_parallelism" {
  type        = number
  default     = 1
  description = "Number of workers for the tests."
}
