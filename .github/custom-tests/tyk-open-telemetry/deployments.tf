kubernetes_config_context = "performance-testing"

analytics_enabled             = false
auth_enabled                  = false
quota_enabled                 = false
rate_limit_enabled            = false
open_telemetry_enabled        = true
open_telemetry_sampling_ratio = "0.5"

tyk_enabled                   = true
tyk_version                   = "v5.3.1"
tyk_deployment_type           = "Deployment"
tyk_replica_count             = 4
tyk_go_gc                     = 1600
tyk_go_max_procs              = 8
tyk_resources_requests_cpu    = "0"
tyk_resources_requests_memory = "0"
tyk_resources_limits_cpu      = "0"
tyk_resources_limits_memory   = "0"

kong_enabled                   = false
kong_version                   = "v5"
kong_deployment_type           = "Deployment"
kong_replica_count             = 1
kong_resources_requests_cpu    = "0"
kong_resources_requests_memory = "0"
kong_resources_limits_cpu      = "0"
kong_resources_limits_memory   = "0"

gravitee_enabled                   = false
gravitee_version                   = "4.1"
gravitee_deployment_type           = "Deployment"
gravitee_replica_count             = 1
gravitee_resources_requests_cpu    = "0"
gravitee_resources_requests_memory = "0"
gravitee_resources_limits_cpu      = "0"
gravitee_resources_limits_memory   = "0"

grafana_service_type = "ClusterIP"