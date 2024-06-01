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
    go_gc           = var.tyk_go_gc
    go_max_procs    = var.tyk_go_max_procs
  }

  kong = {
    enabled         = var.kong_enabled
    version         = var.kong_version
    deployment_type = var.kong_deployment_type
  }

  gravitee = {
    enabled         = var.gravitee_enabled
    version         = var.gravitee_version
    deployment_type = var.gravitee_deployment_type
    nginx_enabled   = var.gravitee_nginx_enabled
  }

  dependencies = {
    grafana = {
      service = {
        type = var.grafana_service_type
      }
    }
  }
}
