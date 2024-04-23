terraform {
  required_providers {
    kubectl = {
      source = "alekc/kubectl"
      version = ">= 2.0.4"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path    = var.kubernetes.config.path
    config_context = var.kubernetes.config.context
  }
}

provider "kubernetes" {
  config_path    = var.kubernetes.config.path
  config_context = var.kubernetes.config.context
}

provider "kubectl" {
  config_path    = var.kubernetes.config.path
  config_context = var.kubernetes.config.context
}