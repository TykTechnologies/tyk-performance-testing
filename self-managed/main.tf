module "deployments" {
  source = "../modules/deployments"

  enable_tyk      = var.enable_tyk
  enable_kong     = var.enable_kong
  enable_gravitee = var.enable_gravitee
  labels          = var.node-labels
  kubernetes      = var.kubernetes
}
