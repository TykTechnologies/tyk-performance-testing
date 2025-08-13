module "dependencies" {
  source = "./dependencies"

  label            = var.labels.dependencies
  grafana          = var.dependencies.grafana
  open_telemetry   = var.open_telemetry
  scaling_webhook  = var.dependencies.scaling_webhook
  cluster_type     = var.cluster_type
  cluster_name     = var.cluster_name
  aws_region       = var.aws_region
  keycloak         = {
    enabled = var.auth.enabled && var.auth.type == "JWT-RSA" ? true : false
  }
}

module "tyk-upstream" {
  source        = "./dependencies/upstream"
  label         = var.labels.tyk-upstream
  namespace     = var.labels.tyk-upstream
  service_count = var.service.host_count

  count = var.tyk.enabled == true ? 1 : 0
}

module "kong-upstream" {
  source        = "./dependencies/upstream"
  label         = var.labels.kong-upstream
  namespace     = var.labels.kong-upstream
  service_count = var.service.host_count

  count = var.kong.enabled == true ? 1 : 0
}

module "gravitee-upstream" {
  source        = "./dependencies/upstream"
  label         = var.labels.gravitee-upstream
  namespace     = var.labels.gravitee-upstream
  service_count = var.service.host_count

  count = var.gravitee.enabled == true ? 1 : 0
}

module "traefik-upstream" {
  source        = "./dependencies/upstream"
  label         = var.labels.traefik-upstream
  namespace     = var.labels.traefik-upstream
  service_count = var.service.host_count

  count = var.traefik.enabled == true ? 1 : 0
}

module "upstream" {
  source     = "./upstream"
  label      = var.labels.upstream
  namespace  = var.labels.upstream
  service    = var.service

  count = var.upstream.enabled == true ? 1 : 0
}

module "tyk" {
  source = "./tyk"

  label           = var.labels.tyk
  resources-label = var.labels.tyk-resources

  gateway_version = var.tyk.version
  license         = var.tyk.license

  deployment_type         = var.tyk.deployment_type
  service_type            = var.tyk.service_type
  hpa                     = var.hpa
  replica_count           = var.replica_count
  external_traffic_policy = var.external_traffic_policy
  resources               = var.resources
  go_gc                   = var.tyk.go_gc
  go_max_procs            = var.tyk.go_max_procs
  profiler                = var.tyk.profiler

  analytics        = var.analytics
  auth             = var.auth
  quota            = var.quota
  rate_limit       = var.rate_limit
  open_telemetry   = var.open_telemetry
  header_injection = var.header_injection

  service = var.service
  
  # Shared storage configuration
  enable_shared_storage = var.enable_shared_storage
  cluster_type         = var.cluster_type
  use_config_maps_for_apis = var.use_config_maps_for_apis

  count = var.tyk.enabled == true ? 1 : 0
  depends_on = [module.dependencies]
}

module "kong" {
  source          = "./kong"
  label           = var.labels.kong
  resources-label = var.labels.kong-resources

  gateway_version = var.kong.version

  deployment_type         = var.kong.deployment_type
  service_type            = var.kong.service_type
  hpa                     = var.hpa
  replica_count           = var.replica_count
  external_traffic_policy = var.external_traffic_policy
  resources               = var.resources

  analytics        = var.analytics
  auth             = var.auth
  quota            = var.quota
  rate_limit       = var.rate_limit
  open_telemetry   = var.open_telemetry
  header_injection = var.header_injection

  service = var.service

  count = var.kong.enabled == true ? 1 : 0
  depends_on = [module.dependencies]
}

module "gravitee" {
  source          = "./gravitee"
  label           = var.labels.gravitee
  resources-label = var.labels.gravitee-resources

  gateway_version = var.gravitee.version
  nginx_enabled   = var.gravitee.nginx_enabled

  deployment_type         = var.gravitee.deployment_type
  service_type            = var.gravitee.service_type
  hpa                     = var.hpa
  replica_count           = var.replica_count
  external_traffic_policy = var.external_traffic_policy
  resources               = var.resources

  analytics        = var.analytics
  auth             = var.auth
  quota            = var.quota
  rate_limit       = var.rate_limit
  open_telemetry   = var.open_telemetry
  header_injection = var.header_injection

  service = var.service

  count = var.gravitee.enabled == true ? 1 : 0
  depends_on = [module.dependencies]
}

module "traefik" {
  source          = "./traefik"
  label           = var.labels.traefik
  resources-label = var.labels.traefik-resources

  gateway_version = var.traefik.version

  deployment_type         = var.traefik.deployment_type
  service_type            = var.traefik.service_type
  hpa                     = var.hpa
  replica_count           = var.replica_count
  external_traffic_policy = var.external_traffic_policy
  resources               = var.resources

  analytics        = var.analytics
  auth             = var.auth
  quota            = var.quota
  rate_limit       = var.rate_limit
  open_telemetry   = var.open_telemetry
  header_injection = var.header_injection

  service = var.service

  count = var.traefik.enabled == true ? 1 : 0
  depends_on = [module.dependencies]
}
