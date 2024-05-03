locals {
  nodes = {
    dependencies       = var.dependencies_nodes_count
    tyk                = var.tyk_enabled      ? var.services_nodes_count : 0
    tyk-upstream       = var.tyk_enabled      ? var.services_nodes_count : 0
    tyk-tests          = var.tyk_enabled      ? var.services_nodes_count : 0
    tyk-resources      = var.tyk_enabled      ? var.resource_nodes_count : 0
    kong               = var.kong_enabled     ? var.services_nodes_count : 0
    kong-upstream      = var.kong_enabled     ? var.services_nodes_count : 0
    kong-tests         = var.kong_enabled     ? var.services_nodes_count : 0
    kong-resources     = var.kong_enabled     ? var.resource_nodes_count : 0
    gravitee           = var.gravitee_enabled ? var.services_nodes_count : 0
    gravitee-upstream  = var.gravitee_enabled ? var.services_nodes_count : 0
    gravitee-tests     = var.gravitee_enabled ? var.services_nodes_count : 0
    gravitee-resources = var.gravitee_enabled ? var.resource_nodes_count : 0
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
