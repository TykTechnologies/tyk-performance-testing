variable "cluster_machine_type" {
  type        = string
  default     = "Standard_F4s_v2"
  description = "Default machine type for cluster."
}

variable "service_machine_type" {
  type        = string
  description = "Machine type for services, overrides cluster_machine_type."
}

variable "upstream_machine_type" {
  type        = string
  description = "Machine type for upstreams, overrides cluster_machine_type."
}

variable "tests_machine_type" {
  type        = string
  description = "Machine type for tests, overrides cluster_machine_type."
}

variable "resources_machine_type" {
  type        = string
  description = "Machine type for resources, overrides cluster_machine_type."
}

variable "dependencies_machine_type" {
  type        = string
  description = "Machine type for dependencies, overrides cluster_machine_type."
}

variable "services_nodes_count" {
  type    = number
  default = 1
}

variable "resource_nodes_count" {
  type    = number
  default = 1
}

variable "dependencies_nodes_count" {
  type    = number
  default = 1
}

variable "tyk_enabled" {
  type    = bool
  default = true
}

variable "kong_enabled" {
  type    = bool
  default = false
}

variable "gravitee_enabled" {
  type    = bool
  default = false
}
