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

variable "scaling_enabled" {
  type        = bool
  default     = false
  description = "Enable dynamic node scaling during the test"
}

variable "cluster_type" {
  type        = string
  default     = "eks"
  description = "Type of Kubernetes cluster (eks, aks, gke)"
}
