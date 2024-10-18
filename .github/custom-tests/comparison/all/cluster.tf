project                   = "ce-team-zaid"
cluster_location          = "us-west1-a"
gke_version               = ""
cluster_machine_type      = "c2-standard-4"
service_machine_type      = ""
upstream_machine_type     = "c2-standard-8"
tests_machine_type        = "c2-standard-8"
resources_machine_type    = ""
dependencies_machine_type = "c2-standard-8"

services_nodes_count     = 1
upstream_nodes_count     = 1
tests_nodes_count        = 1
resource_nodes_count     = 1
dependencies_nodes_count = 2

tyk_enabled      = true
kong_enabled     = true
gravitee_enabled = true