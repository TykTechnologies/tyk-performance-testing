locals {
  # Single source of truth for "service" pools that need >=2 nodes.
  service_pools = ["tyk", "kong", "gravitee", "traefik"]

  nodes = {
    dependencies       = var.dependencies_nodes_count
    tyk                = var.tyk_enabled      ? var.services_nodes_count : 0
    tyk-upstream       = var.tyk_enabled      ? var.upstream_nodes_count : 0
    tyk-tests          = var.tyk_enabled      ? var.tests_nodes_count    : 0
    tyk-resources      = var.tyk_enabled      ? var.resource_nodes_count : 0
    kong               = var.kong_enabled     ? var.services_nodes_count : 0
    kong-upstream      = var.kong_enabled     ? var.upstream_nodes_count : 0
    kong-tests         = var.kong_enabled     ? var.tests_nodes_count    : 0
    kong-resources     = var.kong_enabled     ? var.resource_nodes_count : 0
    gravitee           = var.gravitee_enabled ? var.services_nodes_count : 0
    gravitee-upstream  = var.gravitee_enabled ? var.upstream_nodes_count : 0
    gravitee-tests     = var.gravitee_enabled ? var.tests_nodes_count    : 0
    gravitee-resources = var.gravitee_enabled ? var.resource_nodes_count : 0
    traefik            = var.traefik_enabled  ? var.services_nodes_count : 0
    traefik-upstream   = var.traefik_enabled  ? var.upstream_nodes_count : 0
    traefik-tests      = var.traefik_enabled  ? var.tests_nodes_count    : 0
    traefik-resources  = var.traefik_enabled  ? var.resource_nodes_count : 0
    upstream           = var.upstream_enabled ? var.upstream_nodes_count : 0
    upstream-tests     = var.upstream_enabled ? var.tests_nodes_count    : 0
  }

  machines = {
    dependencies       = var.dependencies_machine_type == "" ? var.cluster_machine_type : var.dependencies_machine_type
    tyk                = var.service_machine_type      == "" ? var.cluster_machine_type : var.service_machine_type
    tyk-upstream       = var.upstream_machine_type     == "" ? var.cluster_machine_type : var.upstream_machine_type
    tyk-tests          = var.tests_machine_type        == "" ? var.cluster_machine_type : var.tests_machine_type
    tyk-resources      = var.resources_machine_type    == "" ? var.cluster_machine_type : var.resources_machine_type
    kong               = var.service_machine_type      == "" ? var.cluster_machine_type : var.service_machine_type
    kong-upstream      = var.upstream_machine_type     == "" ? var.cluster_machine_type : var.upstream_machine_type
    kong-tests         = var.tests_machine_type        == "" ? var.cluster_machine_type : var.tests_machine_type
    kong-resources     = var.resources_machine_type    == "" ? var.cluster_machine_type : var.resources_machine_type
    gravitee           = var.service_machine_type      == "" ? var.cluster_machine_type : var.service_machine_type
    gravitee-upstream  = var.upstream_machine_type     == "" ? var.cluster_machine_type : var.upstream_machine_type
    gravitee-tests     = var.tests_machine_type        == "" ? var.cluster_machine_type : var.tests_machine_type
    gravitee-resources = var.resources_machine_type    == "" ? var.cluster_machine_type : var.resources_machine_type
    traefik            = var.service_machine_type      == "" ? var.cluster_machine_type : var.service_machine_type
    traefik-upstream   = var.upstream_machine_type     == "" ? var.cluster_machine_type : var.upstream_machine_type
    traefik-tests      = var.tests_machine_type        == "" ? var.cluster_machine_type : var.tests_machine_type
    traefik-resources  = var.resources_machine_type    == "" ? var.cluster_machine_type : var.resources_machine_type
    upstream           = var.upstream_machine_type     == "" ? var.cluster_machine_type : var.upstream_machine_type
    upstream-tests     = var.tests_machine_type        == "" ? var.cluster_machine_type : var.tests_machine_type
  }
}

output "min_nodes" {
  value = tomap({
    for key, value in local.nodes :
    key => (contains(local.service_pools, key) ? 2 : 1)
    if tonumber(value) != 0
  })
}

output "nodes" {
  value = tomap({
    for key, value in local.nodes: key => tonumber(value) if tonumber(value) != 0
  })
}

output "labels" {
  value = tomap({
    for key, value in local.nodes: key => key if tonumber(value) != 0
  })
}

output "machines" {
  value = local.machines
}
