module "tyk-httpbin" {
  source = "./httpbin"

  name        = "tyk"
  url         = ""
  oTel        = var.oTel
  parallelism = var.parallelism

  count = var.tests.httpbin == true && var.tyk.enabled == true ? 1 : 0
}

module "kong-httpbin" {
  source = "./httpbin"

  name        = "kong"
  url         = ""
  oTel        = var.oTel
  parallelism = var.parallelism

  count = var.tests.httpbin == true && var.kong.enabled == true ? 1 : 0
}

module "gravitee-httpbin" {
  source = "./httpbin"

  name        = "gravitee"
  url         = ""
  oTel        = var.oTel
  parallelism = var.parallelism

  count = var.tests.httpbin == true && var.gravitee.enabled == true ? 1 : 0
}

