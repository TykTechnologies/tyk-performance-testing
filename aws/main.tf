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
    host                   = module.aws.kubernetes.host
    username               = module.aws.kubernetes.username
    password               = module.aws.kubernetes.password
    token                  = module.aws.kubernetes.token
    client_key             = module.aws.kubernetes.client_key
    client_certificate     = module.aws.kubernetes.client_certificate
    cluster_ca_certificate = module.aws.kubernetes.cluster_ca_certificate
    config_path            = module.aws.kubernetes.config_path
    config_context         = module.aws.kubernetes.config_context
  }
}

provider "kubernetes" {
  host                   = module.aws.kubernetes.host
  username               = module.aws.kubernetes.username
  password               = module.aws.kubernetes.password
  token                  = module.aws.kubernetes.token
  client_key             = module.aws.kubernetes.client_key
  client_certificate     = module.aws.kubernetes.client_certificate
  cluster_ca_certificate = module.aws.kubernetes.cluster_ca_certificate
  config_path            = module.aws.kubernetes.config_path
  config_context         = module.aws.kubernetes.config_context
}

provider "kubectl" {
  host                   = module.aws.kubernetes.host
  username               = module.aws.kubernetes.username
  password               = module.aws.kubernetes.password
  token                  = module.aws.kubernetes.token
  client_key             = module.aws.kubernetes.client_key
  client_certificate     = module.aws.kubernetes.client_certificate
  cluster_ca_certificate = module.aws.kubernetes.cluster_ca_certificate
  config_path            = module.aws.kubernetes.config_path
  config_context         = module.aws.kubernetes.config_context
}

module "aws" {
  source = "../modules/clouds/aws"

  cluster_location     = var.cluster_location
  cluster_machine_type = var.cluster_machine_type
  nodes                = module.h.nodes
}

module "deployments" {
  source = "../modules/deployments"

  tyk      = var.tyk
  kong     = var.kong
  gravitee = var.gravitee

  oTel = var.oTel

  depends_on = [module.aws]
}

module "tests" {
  source = "../modules/tests"

  namespace    = "k6"
  service_name = "tyk"
  service_url  = "gateway-svc-tyk-gateway.tyk.svc:8080"

  tests = var.tests
  oTel  = var.oTel

  depends_on = [module.deployments]
}
