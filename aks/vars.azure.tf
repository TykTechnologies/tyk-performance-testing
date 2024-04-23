variable "cluster_location" {
  type    = string
  default = "westus"
}

variable "cluster_machine_type" {
  type    = string
  default = "Standard_F4s_v2"
}

variable "aks_version" {
  type    = string
  default = "1.27"
}