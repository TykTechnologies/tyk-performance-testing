module "tests" {
  source = "../modules/tests"

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
    parallelism   = var.tests_parallelism
    timestamp     = var.tests_timestamp_enabled
    httpbin       = var.tests_httpbin_enabled
    duration      = var.tests_duration
    virtual_users = var.tests_virtual_users
  }
}
