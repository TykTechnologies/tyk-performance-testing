kubernetes_config_context = "performance-testing"

analytics_database_enabled    = false
analytics_prometheus_enabled  = false
auth_enabled                  = false
quota_enabled                 = false
quota_rate                    = 999999
quota_per                     = 3600
rate_limit_enabled            = false
rate_limit_rate               = 999999
rate_limit_per                = 60
open_telemetry_enabled        = true
open_telemetry_sampling_ratio = "0.5"
header_injection_req_enabled  = false
header_injection_res_enabled  = false

hpa_enabled                 = false
hpa_max_replica_count       = 10
replica_count               = 4
hpa_avg_cpu_util_percentage = 80
external_traffic_policy     = "Local"
resources_requests_cpu      = "0"
resources_requests_memory   = "0"
resources_limits_cpu        = "0"
resources_limits_memory     = "0"

tyk_enabled          = true
tyk_version          = "v5.7"
tyk_deployment_type  = "Deployment"
tyk_service_type     = "ClusterIP"
tyk_go_gc            = 1600
tyk_go_max_procs     = 8
tyk_profiler_enabled = false

kong_enabled         = false
kong_version         = "3.8"
kong_deployment_type = "Deployment"
kong_service_type    = "ClusterIP"

gravitee_enabled         = false
gravitee_version         = "4.5"
gravitee_deployment_type = "Deployment"
gravitee_service_type    = "ClusterIP"

traefik_enabled         = false
traefik_version         = "3.3"
traefik_deployment_type = "Deployment"
traefik_service_type    = "ClusterIP"
