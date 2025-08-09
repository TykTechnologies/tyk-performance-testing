variable "services_nodes_count" {
  type    = number
  default = 2

  validation {
    condition = var.services_nodes_count > 0
    error_message = "Variable services_nodes_count should be 1 or higher"
  }
}

variable "upstream_nodes_count" {
  type    = number
  default = 1

  validation {
    condition = var.upstream_nodes_count > 0
    error_message = "Variable upstream_nodes_count should be 1 or higher"
  }
}

variable "tests_nodes_count" {
  type    = number
  default = 1

  validation {
    condition = var.tests_nodes_count > 0
    error_message = "Variable tests_nodes_count should be 1 or higher"
  }
}

variable "resource_nodes_count" {
  type    = number
  default = 1

  validation {
    condition = var.resource_nodes_count > 0
    error_message = "Variable resource_nodes_count should be 1 or higher"
  }
}

variable "dependencies_nodes_count" {
  type    = number
  default = 1

  validation {
    condition = var.dependencies_nodes_count > 0
    error_message = "Variable resource_nodes_count should be 1 or higher"
  }
}

variable "cluster_machine_type" {
  type        = string
  default     = ""
  description = "Default machine type for cluster."
}

variable "service_machine_type" {
  type        = string
  default     = ""
  description = "Machine type for services, overrides cluster_machine_type."
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