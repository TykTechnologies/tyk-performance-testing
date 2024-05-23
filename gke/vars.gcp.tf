variable "project" {
  type = string
}

variable "cluster_location" {
  type    = string
  default = "us-west1-a"
}

variable "gke_version" {
  type    = string
  default = "1.29.1-gke.1589020"
}
