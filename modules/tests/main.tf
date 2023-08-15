module "httpbin" {
  source = "./httpbin"

  namespace    = var.namespace
  service_name = var.service_name
  service_url  = var.service_url
  parallelism  = var.parallelism

  oTel = var.oTel

  count = var.tests.httpbin == true ? 1 : 0
}

module "timestamp" {
  source = "./timestamp"

  namespace    = var.namespace
  service_name = var.service_name
  service_url  = var.service_url
  parallelism  = var.parallelism

  oTel = var.oTel

  count = var.tests.timestamp == true ? 1 : 0
}