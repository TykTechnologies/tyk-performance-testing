tyk_enabled      = true
kong_enabled     = true
gravitee_enabled = true

tests_fortio_options = "size=2000"
tests_executor       = "constant-arrival-rate"
tests_auth_key_count = 10
tests_ramping_steps  = 10
tests_duration       = 5
tests_rate           = 5000
tests_virtual_users  = 500
tests_parallelism    = 4
