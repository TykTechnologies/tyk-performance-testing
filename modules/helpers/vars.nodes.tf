variable "services_nodes_count" {
  type    = number
  default = 1

  validation {
    condition = var.services_nodes_count > 0
    error_message = "Variable services_nodes_count should be 1 or higher"
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