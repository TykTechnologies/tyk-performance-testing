module "tyk-httpbin" {
  source = "./httpbin"

  name = "tyk"
  url  = "gateway-svc-tyk-gateway.tyk.svc:8080"

  analytics    = var.analytics
  auth         = var.auth
  oTel         = var.oTel
  quota        = var.quota
  rateLimiting = var.rateLimiting

  parallelism = var.parallelism

  count = var.tests.httpbin == true && var.tyk.enabled == true ? 1 : 0
}

module "kong-httpbin" {
  source = "./httpbin"

  name = "kong"
  url  = ""

  analytics    = var.analytics
  auth         = var.auth
  oTel         = var.oTel
  quota        = var.quota
  rateLimiting = var.rateLimiting

  parallelism = var.parallelism

  count = var.tests.httpbin == true && var.kong.enabled == true ? 1 : 0
}

module "gravitee-httpbin" {
  source = "./httpbin"

  name = "gravitee"
  url  = "gravitee-apim-gateway.gravitee.svc:82"

  analytics    = var.analytics
  auth         = var.auth
  oTel         = var.oTel
  quota        = var.quota
  rateLimiting = var.rateLimiting

  parallelism = var.parallelism

  count = var.tests.httpbin == true && var.gravitee.enabled == true ? 1 : 0
}

