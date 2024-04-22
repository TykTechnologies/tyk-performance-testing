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

variable "node_labels" {
  type = object({
    dependencies       = string
    tyk                = string
    tyk-upstream       = string
    tyk-tests          = string
    tyk-resources      = string
    kong               = string
    kong-upstream      = string
    kong-tests         = string
    kong-resources     = string
    gravitee           = string
    gravitee-upstream  = string
    gravitee-tests     = string
    gravitee-resources = string
  })
}
