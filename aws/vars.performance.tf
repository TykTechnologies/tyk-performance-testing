variable "deployment_type" {
  type    = string
  default = "DaemonSet"
}

variable "replica_count" {
  type    = string
  default = 1
}

variable "resources" {
  type    = any
  default = "null"
}

variable "go_gc" {
  type    = string
  default = ""
}

variable "go_max_procs" {
  type    = string
  default = ""
}
