terraform {
  cloud {
    organization = "tyk-performance-testing"

    workspaces {
      name = "eks-cluster-clean-1753787360"
    }
  }
}