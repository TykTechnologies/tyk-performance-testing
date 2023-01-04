module "tests" {
  source = "./modules/tests"

  enable_tyk      = var.enable_tyk
  enable_kong     = var.enable_kong
  enable_gravitee = var.enable_gravitee
  kubernetes      = var.kubernetes
}
