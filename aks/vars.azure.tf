variable "cluster_location" {
  type        = string
  default     = "westus"
  description = "AKS cluster location."
}

variable "aks_version" {
  type        = string
  default     = "1.29"
  description = "AKS cluster version."
}
