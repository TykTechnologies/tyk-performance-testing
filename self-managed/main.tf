module "deployments" {
  source = "../modules/deployments"

  enable_tyk      = var.enable_tyk
  enable_kong     = var.enable_kong
  enable_gravitee = var.enable_gravitee

  labels = var.node-labels

  tyk_enable_oTel         = var.tyk_enable_oTel
  tyk_oTel_sampling_ratio = var.tyk_oTel_sampling_ratio
}


module "tests" {
  source = "../modules/tests"

  namespace    = "k6"
  service_name = "tyk"
  service_url  = "gateway-svc-tyk-tyk-headless.tyk.svc:443"
}