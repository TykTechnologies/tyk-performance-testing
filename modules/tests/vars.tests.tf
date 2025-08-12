variable "tests" {
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

variable "scaling_enabled" {
  type        = bool
  default     = true
  description = "Enable dynamic node scaling during tests"
}

variable "cluster_type" {
  type        = string
  default     = "eks"
  description = "Type of Kubernetes cluster (eks, aks, gke)"
}
