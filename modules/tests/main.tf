module "httpbin" {
  namespace    = var.namespace
  service_name = var.service_name
  service_url  = var.service_url
  parallelism  = var.parallelism
  source       = "./httpbin"
}

module "timestamp" {
  namespace    = var.namespace
  service_name = var.service_name
  service_url  = var.service_url
  parallelism  = var.parallelism
  source       = "./timestamp"
}