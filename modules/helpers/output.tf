locals {
  k6 = {
    k6 = var.provider_nodes
  }
  tyk = var.enable_tyk ? {
    tyk = var.provider_nodes
  } : {}
  kong = var.enable_kong ? {
    kong = var.provider_nodes
  } : {}
  gravitee = var.enable_gravitee ? {
    gravitee = var.provider_nodes
  } : {}
}

output "nodes" {
  value = {
    for key, value in merge(var.worker_nodes, local.k6, local.tyk, local.kong, local.gravitee): key => {
      name       = key
      node_count = tonumber(value)
    }
  }
}
