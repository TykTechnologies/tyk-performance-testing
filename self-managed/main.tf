module "deployments" {
  source = "../modules/deployments"

  labels = var.node-labels

  tyk      = var.tyk
  kong     = var.kong
  gravitee = var.gravitee

  oTel = var.oTel
}


module "tests" {
  source = "../modules/tests"

  namespace    = "k6"
  service_name = "tyk"
  service_url  = "gateway-svc-tyk-gateway.tyk.svc:8080"

  tests = var.tests
  oTel  = var.oTel
}