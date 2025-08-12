module "h" {
  source = "../modules/helpers"

  services_nodes_count      = var.services_nodes_count
  upstream_nodes_count      = var.upstream_nodes_count
  tests_nodes_count         = var.tests_nodes_count
  resource_nodes_count      = var.resource_nodes_count
  dependencies_nodes_count  = var.dependencies_nodes_count
  cluster_machine_type      = var.cluster_machine_type
  service_machine_type      = var.service_machine_type
  upstream_machine_type     = var.upstream_machine_type
  tests_machine_type        = var.tests_machine_type
  resources_machine_type    = var.resources_machine_type
  dependencies_machine_type = var.dependencies_machine_type

  tyk_enabled      = var.tyk_enabled
  kong_enabled     = var.kong_enabled
  gravitee_enabled = var.gravitee_enabled
  traefik_enabled  = var.traefik_enabled
  upstream_enabled = var.upstream_enabled
}

provider "google" {
  project = var.project
}

data "google_client_config" "this" {}

resource "google_container_cluster" "this" {
  name                = "pt-${var.cluster_location}"
  min_master_version  = var.gke_version
  location            = var.cluster_location
  deletion_protection = false

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  monitoring_config {
    managed_prometheus {
      enabled = false
    }
  }
}

resource "google_container_node_pool" "this" {
  for_each   = module.h.nodes
  name       = "${each.key}-np"
  cluster    = google_container_cluster.this.name
  version    = var.gke_version
  location   = google_container_cluster.this.location
  
  # Enable autoscaling for service node pools
  autoscaling {
    min_node_count = contains(["tyk", "kong", "gravitee", "traefik"], each.key) ? 2 : 1
    max_node_count = contains(["tyk", "kong", "gravitee", "traefik"], each.key) ? 6 : 3
    location_policy = "BALANCED"
  }
  
  initial_node_count = each.value

  node_config {
    machine_type = module.h.machines[each.key]
    labels = {
      "node": each.key
    }
  }
}
