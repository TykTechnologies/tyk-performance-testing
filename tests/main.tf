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
    executor      = var.tests_executor
    ramping_steps = var.tests_ramping_steps
    duration      = var.tests_duration
    rate          = var.tests_rate
    virtual_users = var.tests_virtual_users
    parallelism   = var.tests_parallelism

    auth = {
      key_count = var.tests_auth_key_count
    }
  }
}
