module "tyk-httpbin" {
  source = "./httpbin"

  name   = "tyk"
  url    = "gateway-svc-tyk-tyk-gateway.tyk.svc:8080"
  config = var.tests.config

  count = var.tests.httpbin == true && var.tyk.enabled == true ? 1 : 0
}

module "kong-httpbin" {
  source = "./httpbin"

  name   = "kong"
  url    = ""
  config = var.tests.config

  count = var.tests.httpbin == true && var.kong.enabled == true ? 1 : 0
}

module "gravitee-httpbin" {
  source = "./httpbin"

  name   = "gravitee"
  url    = "gravitee-apim-gateway.gravitee.svc:82"
  config = var.tests.config

  count = var.tests.httpbin == true && var.gravitee.enabled == true ? 1 : 0
}

module "test-results-snapshot-httpbin" {
  source = "./snapshot"

  name     = "httpbin"
  duration = var.tests.config.duration

  count      = var.tests.httpbin == true ? 1 : 0
  depends_on = [module.tyk-httpbin, module.kong-httpbin, module.gravitee-httpbin]
}
