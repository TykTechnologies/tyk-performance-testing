module "upstream" {
  source = "./upstream"
  label  = var.labels.upstream
}

module "k6-operator" {
  source = "./k6"
  label  = var.labels.k6
}

module "dependencies" {
  source = "./dependencies"
  label  = var.labels.dependencies
}

module "tyk" {
  source = "./tyk"

  label           = var.labels.tyk
  resources-label = var.labels.tyk-resources

 gateway_version     = var.tyk_version
 enable_oTel         = var.tyk_enable_oTel
 oTel_sampling_ratio = var.tyk_oTel_sampling_ratio

  count = var.enable_tyk == true ? 1 : 0
}

module "kong" {
  source          = "./kong"
  label           = var.labels.kong
  resources-label = var.labels.kong-resources
  count           = var.enable_kong == true ? 1 : 0
}

module "gravitee" {
  source          = "./gravitee"
  label           = var.labels.gravitee
  resources-label = var.labels.gravitee-resources
  count           = var.enable_gravitee == true ? 1 : 0
}
