module "dependencies" {
  source = "./dependencies"

  label       = var.labels.dependencies
  oTelEnabled = var.oTel.enabled
}

module "tyk-upstream" {
  source    = "./upstream"
  label     = var.labels.tyk-upstream
  namespace = var.labels.tyk-upstream

  count = var.tyk.enabled == true ? 1 : 0
}

module "kong-upstream" {
  source = "./upstream"
  label     = var.labels.kong-upstream
  namespace = var.labels.kong-upstream

  count = var.kong.enabled == true ? 1 : 0
}

module "gravitee-upstream" {
  source = "./upstream"
  label     = var.labels.gravitee-upstream
  namespace = var.labels.gravitee-upstream

  count = var.gravitee.enabled == true ? 1 : 0
}

module "tyk" {
  source = "./tyk"

  label           = var.labels.tyk
  resources-label = var.labels.tyk-resources

  gateway_version = var.tyk.version
  analytics       = var.tyk.analytics
  oTel            = var.oTel

  count = var.tyk.enabled == true ? 1 : 0
}

module "kong" {
  source          = "./kong"
  label           = var.labels.kong
  resources-label = var.labels.kong-resources

  gateway_version = var.kong.version
  analytics       = var.kong.analytics
  oTel            = var.oTel

  count = var.kong.enabled == true ? 1 : 0
}

module "gravitee" {
  source          = "./gravitee"
  label           = var.labels.gravitee
  resources-label = var.labels.gravitee-resources

  gateway_version = var.gravitee.version
  analytics       = var.gravitee.analytics
  oTel            = var.oTel

  count = var.gravitee.enabled == true ? 1 : 0
}
