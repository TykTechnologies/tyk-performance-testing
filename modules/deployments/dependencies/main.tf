terraform {
  required_providers {
    kubectl = {
      source = "alekc/kubectl"
      version = ">= 2.0.2"
    }
  }
}

resource "kubernetes_namespace" "dependencies" {
  metadata {
    name = var.namespace
  }
}
