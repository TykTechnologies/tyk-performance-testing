variable "cluster_location" {
  type        = string
  default     = "us-west-1"
  description = "EKS cluster location."
}

variable "eks_version" {
  type        = string
  default     = ""
  description = "EKS cluster version."
}
