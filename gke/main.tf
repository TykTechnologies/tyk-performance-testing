module "h" {
  source = "../modules/helpers"

  services_nodes_count      = var.services_nodes_count
  resource_nodes_count      = var.resource_nodes_count
  dependencies_nodes_count  = var.dependencies_nodes_count

  tyk_enabled      = var.tyk_enabled
  kong_enabled     = var.kong_enabled
  gravitee_enabled = var.gravitee_enabled
}

provider "google" {
  project = var.project
}

data "google_client_config" "this" {}

resource "google_container_cluster" "this" {
  name                = "pt-${var.cluster_machine_type}"
  min_master_version  = var.gke_version
  location            = var.cluster_location
  deletion_protection = false

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "this" {
  for_each   = module.h.nodes
  name       = "${each.key}-np"
  cluster    = google_container_cluster.this.name
  version    = var.gke_version
  location   = google_container_cluster.this.location
  node_count = each.value

  node_config {
    machine_type = var.cluster_machine_type
    labels = {
      "node": each.key
    }
    #    taint = [{
    #      key    = "node"
    #      value  = each.key
    #      effect = "NO_SCHEDULE"
    #    }]
  }
}
