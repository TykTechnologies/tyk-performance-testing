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

  service_nodes   = var.service_nodes
  resource_nodes  = var.resource_nodes
  enable_tyk      = var.enable_tyk
  enable_kong     = var.enable_kong
  enable_gravitee = var.enable_gravitee
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

  enable_tyk      = var.enable_tyk
  enable_kong     = var.enable_kong
  enable_gravitee = var.enable_gravitee

  tyk_enable_oTel         = var.tyk_enable_oTel
  tyk_oTel_sampling_ratio = var.tyk_oTel_sampling_ratio

  depends_on = [module.gcp]
}

module "tests" {
  source = "../modules/tests"

  namespace    = "k6"
  service_name = "tyk"
  service_url  = "gateway-svc-tyk-tyk-headless.tyk.svc:443"

  depends_on = [module.deployments]
}