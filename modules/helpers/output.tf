locals {
  nodes = {
    dependencies       = var.resource_nodes
    tyk                = var.tyk.enabled      ? var.service_nodes  : 0
    tyk-upstream       = var.tyk.enabled      ? var.service_nodes  : 0
    tyk-tests          = var.tyk.enabled      ? var.service_nodes  : 0
    tyk-resources      = var.tyk.enabled      ? var.resource_nodes : 0
    kong               = var.kong.enabled     ? var.service_nodes  : 0
    kong-upstream      = var.kong.enabled     ? var.service_nodes  : 0
    kong-tests         = var.kong.enabled     ? var.service_nodes  : 0
    kong-resources     = var.kong.enabled     ? var.resource_nodes : 0
    gravitee           = var.gravitee.enabled ? var.service_nodes  : 0
    gravitee-upstream  = var.gravitee.enabled ? var.service_nodes  : 0
    gravitee-tests     = var.gravitee.enabled ? var.service_nodes  : 0
    gravitee-resources = var.gravitee.enabled ? var.resource_nodes : 0
  }
}

output "nodes" {
  value = tomap({
    for key, value in local.nodes: key => tonumber(value) if tonumber(value) != 0
  })
}

output "labels" {
  value = tomap({
    for key, _ in local.nodes: key => key
  })
}
