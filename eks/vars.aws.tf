variable "cluster_location" {
  type        = string
  default     = "us-west-1"
  description = "EKS cluster location."
}

variable "eks_version" {
  type        = string
  default     = "1.29"
  description = "EKS cluster version."
}
