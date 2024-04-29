module "h" {
  source = "../modules/helpers"

  services_nodes_count      = var.services_nodes_count
  resource_nodes_count      = var.resource_nodes_count
  dependencies_nodes_count  = var.dependencies_nodes_count

  tyk_enabled      = var.tyk_enabled
  kong_enabled     = var.kong_enabled
  gravitee_enabled = var.gravitee_enabled
}

module "gcp" {
  source = "../modules/clouds/gcp"

  project              = var.project
  cluster_location     = var.cluster_location
  cluster_machine_type = var.cluster_machine_type
  gke_version          = var.gke_version
  nodes                = module.h.nodes
}
