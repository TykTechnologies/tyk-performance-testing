variable "project" {
  type = string
}

variable "cluster_location" {
  type    = string
  default = "us-west1"
}

variable "cluster_machine_type" {
  type    = string
  default = "c2-standard-4"
}
