module "tyk-httpbin" {
  source = "./httpbin"

  name = "tyk"
  url  = "gateway-svc-tyk-gateway.tyk.svc:8080"

  analytics      = var.analytics
  auth           = var.auth
  quota          = var.quota
  rate_limit     = var.rate_limit
  open_telemetry = var.open_telemetry

  parallelism = var.tests.parallelism

  count = var.tests.httpbin == true && var.tyk.enabled == true ? 1 : 0
}

module "kong-httpbin" {
  source = "./httpbin"

  name = "kong"
  url  = ""

  analytics      = var.analytics
  auth           = var.auth
  quota          = var.quota
  rate_limit     = var.rate_limit
  open_telemetry = var.open_telemetry

  parallelism = var.tests.parallelism

  count = var.tests.httpbin == true && var.kong.enabled == true ? 1 : 0
}

module "gravitee-httpbin" {
  source = "./httpbin"

  name = "gravitee"
  url  = "gravitee-apim-gateway.gravitee.svc:82"

  analytics      = var.analytics
  auth           = var.auth
  quota          = var.quota
  rate_limit     = var.rate_limit
  open_telemetry = var.open_telemetry

  parallelism = var.tests.parallelism

  count = var.tests.httpbin == true && var.gravitee.enabled == true ? 1 : 0
}

