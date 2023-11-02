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

  labels = var.node_labels
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