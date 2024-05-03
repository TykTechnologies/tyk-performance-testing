module "h" {
  source = "./modules"

  tyk_enabled      = var.tyk_enabled
  kong_enabled     = var.kong_enabled
  gravitee_enabled = var.gravitee_enabled
}

locals {
  labels = var.node_labels == null ? module.h.labels : var.node_labels
}
