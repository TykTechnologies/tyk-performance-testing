module "upstream" {
  source = "./upstream"
  label  = var.labels.upstream
}

module "k6-operator" {
  source = "./k6"
}

module "dependencies" {
  source = "./dependencies"
  label  = var.labels.dependencies
}

module "tyk" {
  source          = "./tyk"
  label           = var.labels.tyk
  resources-label = var.labels.tyk-resources
  count           = var.enable_tyk == true ? 1 : 0
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
