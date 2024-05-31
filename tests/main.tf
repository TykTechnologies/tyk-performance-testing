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
    timestamp = var.tests_timestamp_enabled
    httpbin   = var.tests_httpbin_enabled
    config = {
      executor      = var.tests_config_executor
      ramping_steps = var.tests_config_ramping_steps
      duration      = var.tests_config_duration
      rate          = var.tests_config_rate
      virtual_users = var.tests_config_virtual_users
      parallelism   = var.tests_config_parallelism

      auth = {
        enabled   = var.tests_config_auth_enabled
        key_count = var.tests_config_auth_key_count
      }
    }
  }
}
