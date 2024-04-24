terraform {
  cloud {
    organization = "tyk-performance-testing"

    workspaces {
      name = "aks-tests"
    }
  }
}