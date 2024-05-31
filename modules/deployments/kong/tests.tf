module "tests" {
  source         = "../tests"
  namespace      = var.namespace
  analytics      = var.analytics
  auth           = var.auth
  quota          = var.quota
  rate_limit     = var.rate_limit
  open_telemetry = var.open_telemetry
}