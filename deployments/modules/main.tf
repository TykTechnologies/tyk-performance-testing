module "dependencies" {
  source = "./dependencies"

  label          = var.labels.dependencies
  grafana        = var.dependencies.grafana
  open_telemetry = var.open_telemetry
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
  license         = var.tyk.license

  deployment_type = var.tyk.deployment_type
  replica_count   = var.tyk.replica_count
  resources       = var.tyk.resources
  go_gc           = var.tyk.go_gc
  go_max_procs    = var.tyk.go_max_procs

  analytics      = var.analytics
  auth           = var.auth
  quota          = var.quota
  rate_limit     = var.rate_limit
  open_telemetry = var.open_telemetry

  count = var.tyk.enabled == true ? 1 : 0
  depends_on = [module.dependencies]
}

module "kong" {
  source          = "./kong"
  label           = var.labels.kong
  resources-label = var.labels.kong-resources

  gateway_version = var.kong.version

  deployment_type = var.kong.deployment_type
  replica_count   = var.kong.replica_count
  resources       = var.kong.resources

  analytics      = var.analytics
  auth           = var.auth
  quota          = var.quota
  rate_limit     = var.rate_limit
  open_telemetry = var.open_telemetry

  count = var.kong.enabled == true ? 1 : 0
  depends_on = [module.dependencies]
}

module "gravitee" {
  source          = "./gravitee"
  label           = var.labels.gravitee
  resources-label = var.labels.gravitee-resources

  gateway_version = var.gravitee.version

  deployment_type = var.gravitee.deployment_type
  replica_count   = var.gravitee.replica_count
  resources       = var.gravitee.resources

  analytics      = var.analytics
  auth           = var.auth
  quota          = var.quota
  rate_limit     = var.rate_limit
  open_telemetry = var.open_telemetry

  count = var.gravitee.enabled == true ? 1 : 0
  depends_on = [module.dependencies]
}
