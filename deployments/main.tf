module "deployments" {
  source = "../modules/deployments"

  labels = local.labels

  analytics = {
    database = {
      enabled = var.analytics_database_enabled
    }
    prometheus = {
      enabled = var.analytics_prometheus_enabled
    }
  }

  auth = {
    enabled = var.auth_enabled
    type    = var.auth_type
  }

  quota = {
    enabled = var.quota_enabled
    rate    = var.quota_rate
    per     = var.quota_per
  }

  rate_limit = {
    enabled = var.rate_limit_enabled
    rate    = var.rate_limit_rate
    per     = var.rate_limit_per
  }

  open_telemetry = {
    enabled        = var.open_telemetry_enabled
    sampling_ratio = var.open_telemetry_sampling_ratio
  }

  header_injection = {
    req = {
      enabled = var.header_injection_req_enabled
    }
    res = {
      enabled = var.header_injection_res_enabled
    }
  }

  hpa = {
    enabled                 = var.hpa_enabled
    max_replica_count       = var.hpa_max_replica_count
    avg_cpu_util_percentage = var.hpa_avg_cpu_util_percentage
  }

  replica_count           = var.replica_count
  external_traffic_policy = var.external_traffic_policy

  resources = {
    requests = {
      cpu    = var.resources_requests_cpu
      memory = var.resources_requests_memory
    }
    limits = {
      cpu    = var.resources_limits_cpu
      memory = var.resources_limits_memory
    }
  }

  tyk = {
    enabled         = var.tyk_enabled
    version         = var.tyk_version
    license         = var.tyk_license
    deployment_type = var.tyk_deployment_type
    service_type    = var.tyk_service_type
    go_gc           = var.tyk_go_gc
    go_max_procs    = var.tyk_go_max_procs
    profiler        = {
      enabled = var.tyk_profiler_enabled
    }
  }

  kong = {
    enabled         = var.kong_enabled
    version         = var.kong_version
    deployment_type = var.kong_deployment_type
    service_type    = var.kong_service_type
  }

  gravitee = {
    enabled         = var.gravitee_enabled
    version         = var.gravitee_version
    deployment_type = var.gravitee_deployment_type
    service_type    = var.gravitee_service_type
    nginx_enabled   = var.gravitee_nginx_enabled
  }

  traefik = {
    enabled         = var.traefik_enabled
    version         = var.traefik_version
    deployment_type = var.traefik_deployment_type
    service_type    = var.traefik_service_type
  }

  upstream = {
    enabled = var.upstream_enabled
  }

  service = {
    route_count = var.service_route_count
    app_count   = var.service_app_count
    host_count  = var.service_host_count
  }

  dependencies = {
    grafana = {
      service = {
        type = var.grafana_service_type
      }
    }
  }
}
