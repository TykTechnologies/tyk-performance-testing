kubernetes_config_context = "performance-testing"

analytics_database_enabled    = true
analytics_prometheus_enabled  = false
auth_enabled                  = false
quota_enabled                 = false
rate_limit_enabled            = false

open_telemetry_enabled                 = true
open_telemetry_sampling_ratio          = "0"
open_telemetry_metrics_enabled         = true
open_telemetry_metrics_runtime_metrics = false

hpa_enabled             = false
replica_count           = 4
external_traffic_policy = "Local"
resources_requests_cpu    = "0"
resources_requests_memory = "0"
resources_limits_cpu      = "0"
resources_limits_memory   = "0"

tyk_enabled         = true
tyk_deployment_type = "Deployment"
tyk_go_gc           = 1600
tyk_go_max_procs    = 8

kong_enabled     = false
gravitee_enabled = false
traefik_enabled  = false

grafana_service_type = "ClusterIP"
