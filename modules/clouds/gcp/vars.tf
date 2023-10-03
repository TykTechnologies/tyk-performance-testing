variable "project" {
  type = string
}

variable "cluster_location" {
  type = string
}

variable "cluster_machine_type" {
  type = string
}

variable "gke_version" {
  type = string
}

variable "nodes" {
  type = map(number)
}
