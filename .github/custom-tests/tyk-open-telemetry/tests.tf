kubernetes_config_context = "performance-testing"

tyk_enabled      = true
kong_enabled     = false
gravitee_enabled = false

tests_timestamp_enabled = true

tests_config_executor      = "constant-vus"
tests_config_duration      = 15
tests_config_rate          = 20000
tests_config_virtual_users = 50
tests_config_parallelism   = 1
