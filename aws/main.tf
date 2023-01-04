module "h" {
  source = "../modules/helpers"

  provider_nodes  = var.provider_nodes
  enable_tyk      = var.enable_tyk
  enable_kong     = var.enable_kong
  enable_gravitee = var.enable_gravitee
  worker_nodes    = var.worker_nodes
}

module "aws" {
  source = "../modules/clouds/aws"

  cluster_location     = var.cluster_location
  cluster_machine_type = var.cluster_machine_type
  nodes                = module.h.nodes
}

module "tests" {
  source = "../modules/tests"

  enable_tyk      = var.enable_tyk
  enable_kong     = var.enable_kong
  enable_gravitee = var.enable_gravitee
  kubernetes      = module.aws.kubernetes
}
