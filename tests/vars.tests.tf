variable "tests_timestamp_enabled" {
  type        = bool
  default     = true
  description = "Turn on timestamp test. This will return a timestamp json object."
}

variable "tests_httpbin_enabled" {
  type        = bool
  default     = false
  description = "Turn on httpbin test. This will return a 200 OK."
}

variable "tests_config_executor" {
  type        = string
  default     = "constant-arrival-rate"
  description = "Choose the executor for the test. Options are: 'constant-vus', 'ramping-vus', 'constant-arrival-rate', 'ramping-arrival-rate'."
}

variable "tests_config_auth_key_count" {
  type        = number
  default     = 100
  description = "Number of Authentication Tokens used for the test per test worker (tests_config_parallelism)."
}

variable "tests_config_ramping_steps" {
  type        = number
  default     = 10
  description = "Number of ramping steps for the test, applies for 'ramping-vus' and 'ramping-arrival-rate' executors."
}

variable "tests_config_duration" {
  type        = number
  default     = 15
  description = "Test duration in minutes."
}

variable "tests_config_rate" {
  type        = number
  default     = 20000
  description = "Test RPS, applies for 'constant-arrival-rate' and 'ramping-arrival-rate' executors."
}

variable "tests_config_virtual_users" {
  type        = number
  default     = 50
  description = "Number of virtual users to be used for the test."
}

variable "tests_config_parallelism" {
  type        = number
  default     = 4
  description = "Number of workers for the tests."
}
