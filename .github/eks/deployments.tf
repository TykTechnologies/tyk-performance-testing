terraform {
  cloud {
    organization = "tyk-performance-testing"

    workspaces {
      name = "eks-deployments"
    }
  }
}