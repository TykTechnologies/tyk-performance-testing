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

module "gcp" {
  source = "../modules/clouds/gcp"

  project              = var.project
  cluster_location     = var.cluster_location
  cluster_machine_type = var.cluster_machine_type
  gke_version          = var.gke_version
  nodes                = module.h.nodes
}

provider "helm" {
  kubernetes {
    host                   = module.gcp.kubernetes.host
    username               = module.gcp.kubernetes.username
    password               = module.gcp.kubernetes.password
    token                  = module.gcp.kubernetes.token
    client_key             = module.gcp.kubernetes.client_key
    client_certificate     = module.gcp.kubernetes.client_certificate
    cluster_ca_certificate = module.gcp.kubernetes.cluster_ca_certificate
    config_path            = module.gcp.kubernetes.config_path
    config_context         = module.gcp.kubernetes.config_context
  }
}

provider "kubernetes" {
  host                   = module.gcp.kubernetes.host
  username               = module.gcp.kubernetes.username
  password               = module.gcp.kubernetes.password
  token                  = module.gcp.kubernetes.token
  client_key             = module.gcp.kubernetes.client_key
  client_certificate     = module.gcp.kubernetes.client_certificate
  cluster_ca_certificate = module.gcp.kubernetes.cluster_ca_certificate
  config_path            = module.gcp.kubernetes.config_path
  config_context         = module.gcp.kubernetes.config_context
}

provider "kubectl" {
  host                   = module.gcp.kubernetes.host
  username               = module.gcp.kubernetes.username
  password               = module.gcp.kubernetes.password
  token                  = module.gcp.kubernetes.token
  client_key             = module.gcp.kubernetes.client_key
  client_certificate     = module.gcp.kubernetes.client_certificate
  cluster_ca_certificate = module.gcp.kubernetes.cluster_ca_certificate
  config_path            = module.gcp.kubernetes.config_path
  config_context         = module.gcp.kubernetes.config_context
}

module "deployments" {
  source = "../modules/deployments"

  tyk      = var.tyk
  kong     = var.kong
  gravitee = var.gravitee

  deployment_type = var.deployment_type
  replica_count   = var.replica_count
  resources       = var.resources
  go_gc           = var.go_gc
  go_max_procs    = var.go_max_procs

  analytics    = var.analytics
  auth         = var.auth
  oTel         = var.oTel
  quota        = var.quota
  rateLimiting = var.rateLimiting

  tests = var.tests

  labels = module.h.labels

  depends_on = [module.gcp]
}

module "tests" {
  source = "../modules/tests"

  tyk      = var.tyk
  kong     = var.kong
  gravitee = var.gravitee

  analytics    = var.analytics
  auth         = var.auth
  oTel         = var.oTel
  quota        = var.quota
  rateLimiting = var.rateLimiting

  tests = var.tests

  depends_on = [module.deployments]
}