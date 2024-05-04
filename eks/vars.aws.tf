variable "cluster_location" {
  type    = string
  default = "us-west-1"
}

variable "cluster_machine_type" {
  type    = string
  default = "c7i.xlarge"
}

variable "eks_version" {
  type    = string
  default = "1.29"
}
