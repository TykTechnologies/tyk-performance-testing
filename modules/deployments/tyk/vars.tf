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

variable "enable_shared_storage" {
  type    = bool
  default = false
  description = "Enable shared storage for API definitions (requires RWX storage class)"
}

variable "cluster_type" {
  type    = string
  default = ""
  description = "Cloud provider type: gke, eks, or aks"
}

variable "use_config_maps_for_apis" {
  type    = bool
  default = true
  description = "Use ConfigMaps to mount API definitions directly (instead of Tyk Operator)"
}
