locals {
  # Generate API definitions as JSON for direct mounting
  api_definitions = {
    for i in range(var.service.route_count) : 
    "api-${i}.json" => jsonencode({
      name = "api-${i}"
      slug = "api-${i}"
      api_id = "api-${i}"
      org_id = "1"
      use_keyless = !(var.auth.enabled || var.rate_limit.enabled || var.quota.enabled)
      use_standard_auth = (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) && var.auth.type == "authToken"
      use_oauth2 = false
      use_openid = false
      use_basic_auth = false
      enable_jwt = (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) && contains(["JWT-RSA", "JWT-HMAC"], var.auth.type)
      auth_configs = {
        authToken = {
          auth_header_name = "Authorization"
        }
      }
      strip_auth_data = true
      jwt_signing_method = var.auth.type == "JWT-HMAC" ? "hmac" : "rsa"
      jwt_source = var.auth.type == "JWT-HMAC" ? "dG9wc2VjcmV0cGFzc3dvcmQ=" : "http://keycloak-service.dependencies.svc:8080/realms/jwt/protocol/openid-connect/certs"
      jwt_identity_base_field = "sub"
      jwt_policy_field_name = "pol"
      jwt_default_policies = (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? ["${var.namespace}/api-policy-${i % var.service.app_count}"] : []
      jwt_issued_at_validation_skew = 0
      jwt_expires_at_validation_skew = 0
      jwt_not_before_validation_skew = 0
      definition = {
        location = "header"
        key = "x-api-version"
      }
      version_data = {
        not_versioned = true
        default_version = "Default"
        versions = {
          Default = {
            name = "Default"
            use_extended_paths = true
            global_headers = var.header_injection.req.enabled ? { "X-API-REQ" = "Foo" } : {}
            global_response_headers = var.header_injection.res.enabled ? { "X-API-RES" = "Bar" } : {}
          }
        }
      }
      proxy = {
        listen_path = "/api-${i}"
        target_url = "http://fortio-${i % var.service.host_count}.tyk-upstream.svc:8080"
        strip_listen_path = true
      }
      active = true
      disable_rate_limit = !var.rate_limit.enabled
      disable_quota = !var.quota.enabled
    })
  }

  # Generate policy definitions as JSON (with policy ID as the key)
  policy_definitions = var.auth.enabled || var.rate_limit.enabled || var.quota.enabled ? {
    for i in range(var.service.app_count) :
    "api-policy-${i}.json" => jsonencode({
      "${var.namespace}/api-policy-${i}" = {
        name = "api-policy-${i}"
        org_id = "1"
        rate = var.rate_limit.enabled ? var.rate_limit.rate : -1
        per = var.rate_limit.enabled ? var.rate_limit.per : -1
        quota_max = var.quota.enabled ? var.quota.rate : -1
        quota_renewal_rate = var.quota.enabled ? var.quota.per : -1
        throttle_interval = -1
        throttle_retry_limit = -1
        active = true
        access_rights = {
          "api-${i % var.service.route_count}" = {
            api_name = "api-${i % var.service.route_count}"
            api_id = "api-${i % var.service.route_count}"
            versions = ["Default"]
          }
        }
      }
    })
  } : {}
}

# Create ConfigMap with API definitions
resource "kubernetes_config_map" "api-definitions" {
  count = var.use_config_maps_for_apis ? 1 : 0
  
  metadata {
    name      = "tyk-api-definitions"
    namespace = var.namespace
  }

  data = local.api_definitions

  depends_on = [kubernetes_namespace.tyk]
}

# Create ConfigMap with policy definitions
resource "kubernetes_config_map" "policy-definitions" {
  count = var.use_config_maps_for_apis && (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? 1 : 0
  
  metadata {
    name      = "tyk-policy-definitions"
    namespace = var.namespace
  }

  data = local.policy_definitions

  depends_on = [kubernetes_namespace.tyk]
}