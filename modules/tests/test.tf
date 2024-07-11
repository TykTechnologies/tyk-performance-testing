module "tyk-timestamp" {
  source = "./timestamp"

  name   = "tyk"
  url    = "gateway-svc-tyk-tyk-gateway.tyk.svc:8080"
  config = var.tests.config

  count = var.tyk.enabled == true ? 1 : 0
}

module "kong-timestamp" {
  source = "./timestamp"

  name   = "kong"
  url    = "kong-gateway-proxy.kong.svc:80"
  config = var.tests.config

  count = var.kong.enabled == true ? 1 : 0
}

module "gravitee-timestamp" {
  source = "./timestamp"

  name   = "gravitee"
  url    = "gravitee-apim-gateway.gravitee.svc:82"
  config = var.tests.config

  count = var.gravitee.enabled == true ? 1 : 0
}

module "test-results-snapshot-timestamp" {
  source = "./snapshot"

  name     = "timestamp"
  duration = var.tests.config.duration

  count      = var.tests.timestamp == true ? 1 : 0
  depends_on = [module.tyk-timestamp, module.kong-timestamp, module.gravitee-timestamp]
}
