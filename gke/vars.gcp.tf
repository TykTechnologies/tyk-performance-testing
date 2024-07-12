variable "project" {
  type       = string
  description = "GCP project."
}

variable "cluster_location" {
  type        = string
  default     = "us-west1-a"
  description = "GKE cluster location."
}

variable "gke_version" {
  type        = string
  default     = "1.29.5-gke.1091002"
  description = "GKE cluster version."
}
