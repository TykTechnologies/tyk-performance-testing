module "tests" {
  source = "../modules/tests"

  analytics = {
    enabled = var.analytics_enabled
  }

  auth = {
    enabled = var.auth_enabled
  }

  quota = {
    enabled = var.quota_enabled
  }

  rate_limit = {
    enabled = var.rate_limit_enabled
  }

  open_telemetry = {
    enabled        = var.open_telemetry_enabled
    sampling_ratio = var.open_telemetry_sampling_ratio
  }

  tyk = {
    enabled = var.tyk_enabled
  }

  kong = {
    enabled = var.kong_enabled
  }

  gravitee = {
    enabled = var.gravitee_enabled
  }

  tests = {
    parallelism = var.tests_parallelism
    timestamp   = var.tests_timestamp_enabled
    httpbin     = var.tests_timestamp_enabled
  }
}
