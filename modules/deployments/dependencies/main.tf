terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.2.0"
    }
  }
}

resource "kubernetes_namespace" "dependencies" {
  metadata {
    name = var.namespace
  }
}