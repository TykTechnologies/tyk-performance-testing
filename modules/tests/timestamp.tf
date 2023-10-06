module "tyk-timestamp" {
  source = "./timestamp"

  name = "tyk"
  url  = "gateway-svc-tyk-gateway.tyk.svc:8080"

  analytics    = var.analytics
  auth         = var.auth
  oTel         = var.oTel
  quota        = var.quota
  rateLimiting = var.rateLimiting

  parallelism = var.parallelism

  count = var.tests.timestamp == true && var.tyk.enabled == true ? 1 : 0
}

module "kong-timestamp" {
  source = "./timestamp"

  name = "kong"
  url  = ""

  analytics    = var.analytics
  auth         = var.auth
  oTel         = var.oTel
  quota        = var.quota
  rateLimiting = var.rateLimiting

  parallelism = var.parallelism

  count = var.tests.timestamp == true && var.kong.enabled == true ? 1 : 0
}

module "gravitee-timestamp" {
  source = "./timestamp"

  name = "gravitee"
  url  = "gravitee-apim-gateway.gravitee.svc:82"

  analytics    = var.analytics
  auth         = var.auth
  oTel         = var.oTel
  quota        = var.quota
  rateLimiting = var.rateLimiting

  parallelism = var.parallelism

  count = var.tests.timestamp == true && var.gravitee.enabled == true ? 1 : 0
}

