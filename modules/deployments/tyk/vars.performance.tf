variable "deployment_type" {
  type = string
}

variable "replica_count" {
  type = string
}

variable "resources" {
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
}

variable "go_gc" {
  type = string
}

variable "go_max_procs" {
  type = string
}
