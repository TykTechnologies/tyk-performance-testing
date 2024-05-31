module "tests" {
  source    = "../tests"
  namespace = var.namespace
  auth      = var.auth
}