module "h" {
  source = "../modules/helpers"

  provider_nodes  = var.provider_nodes
  resource_nodes  = var.resource_nodes
  enable_tyk      = var.enable_tyk
  enable_kong     = var.enable_kong
  enable_gravitee = var.enable_gravitee
}

module "aws" {
  source = "../modules/clouds/aws"

  cluster_location     = var.cluster_location
  cluster_machine_type = var.cluster_machine_type
  nodes                = module.h.nodes
}

module "deployments" {
  source = "../modules/deployments"

  enable_tyk      = var.enable_tyk
  enable_kong     = var.enable_kong
  enable_gravitee = var.enable_gravitee
  kubernetes      = module.aws.kubernetes
}
