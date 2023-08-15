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

 gateway_version = var.tyk.version
 oTel            = var.oTel

  count = var.tyk.enabled == true ? 1 : 0
}

module "kong" {
  source          = "./kong"
  label           = var.labels.kong
  resources-label = var.labels.kong-resources

  gateway_version = var.tyk.version
  oTel            = var.oTel

  count = var.kong.enabled == true ? 1 : 0
}

module "gravitee" {
  source          = "./gravitee"
  label           = var.labels.gravitee
  resources-label = var.labels.gravitee-resources

  gateway_version = var.tyk.version
  oTel            = var.oTel

  count = var.gravitee.enabled == true ? 1 : 0
}
