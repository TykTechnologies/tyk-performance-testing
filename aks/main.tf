module "h" {
  source = "../modules/helpers"

  services_nodes_count = var.services_nodes_count
  resource_nodes_count = var.resource_nodes_count

  tyk_enabled      = var.tyk_enabled
  kong_enabled     = var.kong_enabled
  gravitee_enabled = var.gravitee_enabled
}

module "azure" {
  source = "../modules/clouds/azure"

  cluster_location     = var.cluster_location
  cluster_machine_type = var.cluster_machine_type
  aks_version          = var.aks_version
  nodes                = module.h.nodes
}
