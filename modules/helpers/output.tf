locals {
  nodes = {
    upstream           = var.service_nodes
    dependencies       = var.resource_nodes
    k6                 = var.service_nodes
    tyk                = var.enable_tyk      ? var.service_nodes : 0
    tyk-resources      = var.enable_tyk      ? var.resource_nodes : 0
    kong               = var.enable_kong     ? var.service_nodes : 0
    kong-resources     = var.enable_kong     ? var.resource_nodes : 0
    gravitee           = var.enable_gravitee ? var.service_nodes : 0
    gravitee-resources = var.enable_gravitee ? var.resource_nodes : 0
  }
}

output "nodes" {
  value = {
    for key, value in local.nodes: key => {
      name       = key
      node_count = tonumber(value)
    } if tonumber(value) != 0
  }
}
