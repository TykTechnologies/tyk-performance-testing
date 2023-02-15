provider "google" {
  project = var.project
}

data "google_client_config" "this" {}

resource "google_container_cluster" "this" {
  name               = "pt-${var.cluster_machine_type}"
  min_master_version = "1.22.16-gke.2000"
  location           = var.cluster_location

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "this" {
  for_each   = var.nodes
  name       = "${each.value.name}-np"
  cluster    = google_container_cluster.this.name
  version    = "1.22.16-gke.2000"
  location   = google_container_cluster.this.location
  node_count = each.value.node_count

  node_config {
    machine_type = var.cluster_machine_type
    labels = {
      "node": each.value.name
    }
  }
}

output "kubernetes" {
  value = {
    host                   = "https://${google_container_cluster.this.endpoint}"
    username               = null
    password               = null
    token                  = data.google_client_config.this.access_token
    client_key             = null
    client_certificate     = null
    cluster_ca_certificate = base64decode(google_container_cluster.this.master_auth[0].cluster_ca_certificate)
    config_path            = null
    config_context         = null
  }

  depends_on = [google_container_cluster.this, google_container_node_pool.this]
}
