analytics_database_enabled    = false
analytics_prometheus_enabled  = true
auth_enabled                  = true
auth_type                     = "authToken"
quota_enabled                 = false
quota_rate                    = 999999
quota_per                     = 3600
rate_limit_enabled            = true
rate_limit_rate               = 999999
rate_limit_per                = 60
open_telemetry_enabled        = true
open_telemetry_sampling_ratio = "0.75"

hpa_enabled                 = false
hpa_max_replica_count       = 10
replica_count               = 4
hpa_avg_cpu_util_percentage = 80
external_traffic_policy     = "local"
resources_requests_cpu      = "750m"
resources_requests_memory   = "2048Mi"
resources_limits_cpu        = "750m"
resources_limits_memory     = "2048Mi"

tyk_enabled         = true
tyk_version         = "v5.6"
tyk_deployment_type = "Deployment"
tyk_go_gc           = 1600
tyk_go_max_procs    = 8

kong_enabled         = true
kong_version         = "3.6"
kong_deployment_type = "Deployment"

gravitee_enabled         = false
gravitee_version         = "4.4"
gravitee_deployment_type = "Deployment"
gravitee_nginx_enabled   = false

grafana_service_type = "ClusterIP"