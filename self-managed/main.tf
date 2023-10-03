module "deployments" {
  source = "../modules/deployments"

  labels   = var.node-labels
  tyk      = var.tyk
  kong     = var.kong
  gravitee = var.gravitee
  oTel     = var.oTel
}


module "tests" {
  source = "../modules/tests"

  tyk      = var.tyk
  kong     = var.kong
  gravitee = var.gravitee
  oTel     = var.oTel
  tests    = var.tests
}