module "deployments" {
  source = "../modules/deployments"

  labels = local.labels

  analytics = {
    enabled = var.analytics_enabled
  }

  auth = {
    enabled = var.auth_enabled
  }

  quota = {
    enabled = var.quota_enabled
  }

  rate_limit = {
    enabled = var.rate_limit_enabled
  }

  open_telemetry = {
    enabled        = var.open_telemetry_enabled
    sampling_ratio = var.open_telemetry_sampling_ratio
  }

  tyk = {
    enabled         = var.tyk_enabled
    version         = var.tyk_version
    license         = var.tyk_license
    deployment_type = var.tyk_deployment_type
    replica_count   = var.tyk_replica_count
    go_gc           = var.tyk_go_gc
    go_max_procs    = var.tyk_go_max_procs
    resources = {
      requests = {
        cpu    = var.tyk_resources_requests_cpu
        memory = var.tyk_resources_requests_memory
      }
      limits = {
        cpu    = var.tyk_resources_limits_cpu
        memory = var.tyk_resources_limits_memory
      }
    }
  }

  kong = {
    enabled         = var.kong_enabled
    version         = var.kong_version
    deployment_type = var.kong_deployment_type
    replica_count   = var.kong_replica_count
    resources = {
      requests = {
        cpu    = var.kong_resources_requests_cpu
        memory = var.kong_resources_requests_memory
      }
      limits = {
        cpu    = var.kong_resources_limits_cpu
        memory = var.kong_resources_limits_memory
      }
    }
  }

  gravitee = {
    enabled         = var.gravitee_enabled
    version         = var.gravitee_version
    deployment_type = var.gravitee_deployment_type
    replica_count   = var.gravitee_replica_count
    resources = {
      requests = {
        cpu    = var.gravitee_resources_requests_cpu
        memory = var.gravitee_resources_requests_memory
      }
      limits = {
        cpu    = var.gravitee_resources_limits_cpu
        memory = var.gravitee_resources_limits_memory
      }
    }
  }

  dependencies = {
    grafana = {
      service = {
        type = var.grafana_service_type
      }
    }
  }
}
