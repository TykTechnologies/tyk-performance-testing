locals {
  nodes = {
    upstream           = var.service_nodes
    dependencies       = var.resource_nodes
    k6                 = var.service_nodes
    tyk                = var.tyk.enabled      ? var.service_nodes  : 0
    tyk-resources      = var.tyk.enabled      ? var.resource_nodes : 0
    kong               = var.kong.enabled     ? var.service_nodes  : 0
    kong-resources     = var.kong.enabled     ? var.resource_nodes : 0
    gravitee           = var.gravitee.enabled ? var.service_nodes  : 0
    gravitee-resources = var.gravitee.enabled ? var.resource_nodes : 0
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
