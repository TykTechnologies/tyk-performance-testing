terraform {
  cloud {
    organization = "tyk-performance-testing"

    workspaces {
      name = "gke-deployments"
    }
  }
}