kubernetes_config_context = "performance-testing"

tyk_enabled      = true
kong_enabled     = false
gravitee_enabled = false

tests_fortio_options = "size=20"
tests_executor       = "constant-vus"
tests_duration       = 15
tests_rate           = 20000
tests_virtual_users  = 50
tests_parallelism    = 1
