locals {
  nodes = {
    upstream           = var.provider_nodes
    k6                 = var.provider_nodes
    tyk                = var.enable_tyk      ? var.provider_nodes : 0
    tyk-resources      = var.enable_tyk      ? var.provider_nodes : 0
    kong               = var.enable_kong     ? var.provider_nodes : 0
    kong-resources     = var.enable_tyk      ? var.provider_nodes : 0
    gravitee           = var.enable_gravitee ? var.provider_nodes : 0
    gravitee-resources = var.enable_tyk      ? var.provider_nodes : 0
  }
}

output "nodes" {
  value = {
    for key, value in local.nodes: key => {
      name       = key
      node_count = tonumber(value)
    }
  }
}
