module "tyk-test" {
  source = "./test"

  name   = "tyk"
  url    = "gateway-svc-tyk-tyk-gateway.tyk.svc:8080"
  config = var.tests

  count = var.tyk.enabled == true ? 1 : 0
}

module "kong-test" {
  source = "./test"

  name   = "kong"
  url    = "kong-gateway-proxy.kong.svc:80"
  config = var.tests

  count = var.kong.enabled == true ? 1 : 0
}

module "gravitee-test" {
  source = "./test"

  name   = "gravitee"
  url    = "gravitee-apim-gateway.gravitee.svc:82"
  config = var.tests

  count = var.gravitee.enabled == true ? 1 : 0
}

module "results-snapshot" {
  source = "./snapshot"

  name     = "snapshot"
  duration = var.tests.duration

  depends_on = [module.tyk-test, module.kong-test, module.gravitee-test]
}
