cluster_location          = "westus"
cluster_machine_type      = "Standard_F8s_v2"
service_machine_type      = ""
upstream_machine_type     = ""
tests_machine_type        = ""
resources_machine_type    = ""
dependencies_machine_type = ""

services_nodes_count     = 1
upstream_nodes_count     = 1
tests_nodes_count        = 1
resource_nodes_count     = 1
dependencies_nodes_count = 2

tyk_enabled      = true
kong_enabled     = false
gravitee_enabled = false
traefik_enabled  = false
