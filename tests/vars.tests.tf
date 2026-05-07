variable "tests_fortio_options" {
  type        = string
  default     = "size=20"
  description = "Set the parameters for the request to fortio-server. Read more at https://github.com/fortio/fortio?tab=readme-ov-file#server-urls-and-features"
}

variable "tests_executor" {
  type        = string
  default     = "autoscaling-gradual"
  description = "Choose the executor for the test. Options are: 'constant-vus', 'ramping-vus', 'constant-arrival-rate', 'ramping-arrival-rate', 'externally-controlled', 'autoscaling-gradual'."
}

variable "tests_auth_key_count" {
  type        = number
  default     = 10000
  description = "Number of Authentication Tokens used for the test per test worker (tests_parallelism)."
}

variable "tests_auth_key_random_selection" {
  type        = bool
  default     = true
  description = "When true, each request picks a token uniformly at random from the full key pool, decoupling token choice from the route index. Use this to drive high-cardinality DRL bucket usage (e.g. to repro Tyk PR 8180). When false the script falls back to keys[i % keys.length] where i is the route index."
}

variable "tests_auth_key_rolling" {
  type        = bool
  default     = false
  description = "When true (and auth_type=JWT-HMAC), the k6 default function signs a fresh JWT with a brand-new sub on every request instead of picking from the pre-built keys pool. This produces unbounded session/DRL-bucket cardinality, which is the cleanest signal for memory-leak regressions like Tyk PR 8180: with the leak, gateway memory climbs linearly forever; without it, cleanup evicts expired buckets and memory plateaus. Default false; setup() still pre-builds the 10k pool either way to warm the buckets."
}

variable "tests_ramping_steps" {
  type        = number
  default     = 10
  description = "Number of ramping steps for the test, applies for 'ramping-vus' and 'ramping-arrival-rate' executors."
}

variable "tests_duration" {
  type        = number
  default     = 30
  description = "Test duration in minutes."
}

variable "tests_rate" {
  type        = number
  default     = 15000
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

variable "test_segment" {
  type        = number
  default     = 1
  description = "Current test segment number (for segmented long tests)"
}

variable "total_segments" {
  type        = number
  default     = 1
  description = "Total number of test segments"
}
