module "h" {
  source = "../modules/helpers"

  tyk_enabled      = var.tyk_enabled
  kong_enabled     = var.kong_enabled
  gravitee_enabled = var.gravitee_enabled
  traefik_enabled  = var.traefik_enabled
  upstream_enabled = var.upstream_enabled
}

locals {
  # Use static labels to avoid computed dependency issues
  labels = var.node_labels == null ? {
    dependencies       = "dependencies"
    tyk                = "tyk"
    tyk-upstream       = "tyk-upstream"
    tyk-tests          = "tyk-tests"
    tyk-resources      = "tyk-resources"
    kong               = "kong"
    kong-upstream      = "kong-upstream"
    kong-tests         = "kong-tests"
    kong-resources     = "kong-resources"
    gravitee           = "gravitee"
    gravitee-upstream  = "gravitee-upstream"
    gravitee-tests     = "gravitee-tests"
    gravitee-resources = "gravitee-resources"
    traefik            = "traefik"
    traefik-upstream   = "traefik-upstream"
    traefik-tests      = "traefik-tests"
    traefik-resources  = "traefik-resources"
    upstream           = "upstream"
    upstream-tests     = "upstream-tests"
  } : var.node_labels
}
