variable "project" {
  type = string
}

variable "cluster_location" {
  type    = string
  default = "us-west1-a"
}

variable "cluster_machine_type" {
  type    = string
  default = "c2-standard-4"
}

variable "gke_version" {
  type    = string
  default = "1.27.4-gke.900"
}
