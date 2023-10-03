terraform {
  required_providers {
    kubectl = {
      source = "alekc/kubectl"
      version = ">= 2.0.2"
    }
  }
}

module "h" {
  source = "../modules/helpers"

  service_nodes  = var.service_nodes
  resource_nodes = var.resource_nodes

  tyk      = var.tyk
  kong     = var.kong
  gravitee = var.gravitee
}

provider "helm" {
  kubernetes {
    host                   = module.azure.kubernetes.host
    username               = module.azure.kubernetes.username
    password               = module.azure.kubernetes.password
    token                  = module.azure.kubernetes.token
    client_key             = module.azure.kubernetes.client_key
    client_certificate     = module.azure.kubernetes.client_certificate
    cluster_ca_certificate = module.azure.kubernetes.cluster_ca_certificate
    config_path            = module.azure.kubernetes.config_path
    config_context         = module.azure.kubernetes.config_context
  }
}

provider "kubernetes" {
  host                   = module.azure.kubernetes.host
  username               = module.azure.kubernetes.username
  password               = module.azure.kubernetes.password
  token                  = module.azure.kubernetes.token
  client_key             = module.azure.kubernetes.client_key
  client_certificate     = module.azure.kubernetes.client_certificate
  cluster_ca_certificate = module.azure.kubernetes.cluster_ca_certificate
  config_path            = module.azure.kubernetes.config_path
  config_context         = module.azure.kubernetes.config_context
}

provider "kubectl" {
  host                   = module.azure.kubernetes.host
  username               = module.azure.kubernetes.username
  password               = module.azure.kubernetes.password
  token                  = module.azure.kubernetes.token
  client_key             = module.azure.kubernetes.client_key
  client_certificate     = module.azure.kubernetes.client_certificate
  cluster_ca_certificate = module.azure.kubernetes.cluster_ca_certificate
  config_path            = module.azure.kubernetes.config_path
  config_context         = module.azure.kubernetes.config_context
}

module "azure" {
  source = "../modules/clouds/azure"

  cluster_location     = var.cluster_location
  cluster_machine_type = var.cluster_machine_type
  nodes                = module.h.nodes
}

module "deployments" {
  source = "../modules/deployments"

  tyk      = var.tyk
  kong     = var.kong
  gravitee = var.gravitee
  oTel     = var.oTel
  labels   = module.h.labels

  depends_on = [module.azure]
}

module "tests" {
  source = "../modules/tests"

  tyk      = var.tyk
  kong     = var.kong
  gravitee = var.gravitee
  oTel  = var.oTel
  tests = var.tests

  depends_on = [module.deployments]
}

