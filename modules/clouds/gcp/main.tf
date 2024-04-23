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
  for_each   = var.nodes
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

resource "null_resource" "kube_config" {
  provisioner "local-exec" {
    command = <<EOT
      [[ $(kubectl config get-contexts performance-testing-gke | wc -l) -eq 2 ]] && kubectl config delete-context performance-testing-gke

      gcloud container clusters get-credentials ${google_container_cluster.this.name} \
        --region ${google_container_cluster.this.location} \
        --project ${google_container_cluster.this.project}

      kubectl config rename-context $(kubectl config current-context) performance-testing-gke
    EOT
  }

  depends_on = [google_container_cluster.this, google_container_node_pool.this]
}
