cluster_machine_type      = "c2-standard-4"
upstream_machine_type     = "c2-standard-8"
tests_machine_type        = "c2-standard-8"
dependencies_machine_type = "c2-standard-8"

dependencies_nodes_count = 2

tyk_enabled      = true
kong_enabled     = true
gravitee_enabled = true
traefik_enabled  = true
upstream_enabled = true