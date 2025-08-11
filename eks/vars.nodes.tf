variable "cluster_machine_type" {
  type        = string
  default     = "c5.xlarge"
  description = "Default machine type for cluster."
}

variable "service_machine_type" {
  type        = string
  default     = ""
  description = "Machine type for services, overrides cluster_machine_type."
}

variable "traefik_enabled" {
  type        = bool
  default     = false
  description = "Enable Traefik services."
}

variable "upstream_machine_type" {
  type        = string
  default     = ""
  description = "Machine type for upstreams, overrides cluster_machine_type."
}

variable "tests_machine_type" {
  type        = string
  default     = ""
  description = "Machine type for tests, overrides cluster_machine_type."
}

variable "resources_machine_type" {
  type        = string
  default     = ""
  description = "Machine type for resources, overrides cluster_machine_type."
}

variable "dependencies_machine_type" {
  type        = string
  default     = ""
  description = "Machine type for dependencies, overrides cluster_machine_type."
}

variable "services_nodes_count" {
  type        = number
  default     = 2
  description = "Number of nodes for each of the gateway services."
}

variable "upstream_nodes_count" {
  type        = number
  default     = 1
  description = "Number of nodes for each of the upstream services."
}

variable "tests_nodes_count" {
  type        = number
  default     = 1
  description = "Number of nodes for each of the tests services."
}

variable "resource_nodes_count" {
  type        = number
  default     = 1
  description = "Number of nodes for each of the gateway resources."
}

variable "dependencies_nodes_count" {
  type        = number
  default     = 1
  description = "Number of nodes for the test dependencies."
}

variable "tyk_enabled" {
  type        = bool
  default     = true
  description = "Enable Tyk services."
}

variable "kong_enabled" {
  type        = bool
  default     = false
  description = "Enable Kong services."
}

variable "gravitee_enabled" {
  type        = bool
  default     = false
  description = "Enable Gravitee services."
}

variable "upstream_enabled" {
  type        = bool
  default     = false
  description = "Enable Fortio upstream service for baseline testing."
}
