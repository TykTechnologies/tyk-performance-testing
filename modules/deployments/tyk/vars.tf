variable "namespace" {
  type    = string
  default = "tyk"
}

variable "license" {
  type = string
}

variable "label" {
  type = string
}

variable "resources-label" {
  type = string
}

variable "gateway_version" {
  type = string
}

// Removed enable_shared_storage and cluster_type variables
// No longer needed since we're using ConfigMaps instead of shared storage

variable "use_config_maps_for_apis" {
  type    = bool
  default = true
  description = "Use ConfigMaps to mount API definitions directly (instead of Tyk Operator)"
}

variable "cluster_type" {
  type        = string
  description = "Kubernetes provider (aks|eks|gke|other) used to choose the correct nodeSelector key."
}
