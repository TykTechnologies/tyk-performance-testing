variable "cluster_location" {
  type        = string
  default     = "westus"
  description = "AKS cluster location."
}

variable "aks_version" {
  type        = string
  default     = ""
  description = "AKS cluster version."
}
