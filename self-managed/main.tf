module "deployments" {
  source = "../modules/deployments"

  tyk      = var.tyk
  kong     = var.kong
  gravitee = var.gravitee

  analytics    = var.analytics
  auth         = var.auth
  oTel         = var.oTel
  quota        = var.quota
  rateLimiting = var.rateLimiting

  tests = var.tests

  labels = var.node-labels
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
}