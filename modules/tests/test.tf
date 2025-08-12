module "tyk-test" {
  source = "./test"

  name            = "tyk"
  service_name    = "gateway-svc-tyk-tyk-gateway"
  service_port    = 8080
  config          = var.tests
  scaling_enabled = var.scaling_enabled
  cluster_type    = var.cluster_type

  count = var.tyk.enabled == true ? 1 : 0
}

module "kong-test" {
  source = "./test"

  name            = "kong"
  service_name    = "kong-gateway-proxy"
  service_port    = 80
  config          = var.tests
  scaling_enabled = var.scaling_enabled
  cluster_type    = var.cluster_type

  count = var.kong.enabled == true ? 1 : 0
}

module "gravitee-test" {
  source = "./test"

  name            = "gravitee"
  service_name    = "gravitee-apim-gateway"
  service_port    = 82
  config          = var.tests
  scaling_enabled = var.scaling_enabled
  cluster_type    = var.cluster_type

  count = var.gravitee.enabled == true ? 1 : 0
}

module "traefik-test" {
  source = "./test"

  name            = "traefik"
  service_name    = "traefik"
  service_port    = 80
  config          = var.tests
  scaling_enabled = var.scaling_enabled
  cluster_type    = var.cluster_type

  count = var.traefik.enabled == true ? 1 : 0
}

module "upstream-test" {
  source = "./test"

  name            = "upstream"
  service_name    = "fortio"
  service_port    = 8080
  config          = var.tests
  scaling_enabled = var.scaling_enabled
  cluster_type    = var.cluster_type

  count = var.upstream.enabled == true ? 1 : 0
}

module "results-snapshot" {
  source = "./snapshot"

  name     = "snapshot"
  duration = var.tests.duration

  depends_on = [module.tyk-test, module.kong-test, module.gravitee-test]
}
