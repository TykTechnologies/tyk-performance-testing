locals {
  # JWT auth wiring for the configmap path. The operator path (operator-api.tf)
  # already does this; we have to mirror it here so use_config_maps_for_apis=true
  # (the default) honours auth_type=JWT-HMAC / JWT-RSA. jwt_identity_base_field
  # is intentionally "sub" so that unique JWT subjects produce unique Tyk
  # sessions (and therefore unique DRL rate-limit buckets).
  is_jwt       = var.auth.type == "JWT-RSA" || var.auth.type == "JWT-HMAC"
  enable_jwt   = var.auth.enabled && local.is_jwt
  use_std_auth = var.auth.enabled && var.auth.type == "authToken"
  jwt_source   = var.auth.type == "JWT-HMAC" ? "dG9wc2VjcmV0cGFzc3dvcmQ=" : "http://keycloak-service.dependencies.svc:8080/realms/jwt/protocol/openid-connect/certs"

  # Generate API definitions as JSON for direct mounting
  api_definitions = {
    for i in range(var.service.route_count) :
    "api-${i}.json" => jsonencode(merge({
      name              = "api-${i}"
      api_id            = "api-${i}"
      org_id            = "1"
      use_keyless       = !var.auth.enabled
      use_standard_auth = local.use_std_auth
      auth              = var.auth.enabled ? { auth_header_name = "Authorization" } : {}
      definition = {
        location = "header"
        key      = "x-api-version"
      }
      version_data = {
        not_versioned   = true
        default_version = ""
        versions = {
          Default = {
            name               = "Default"
            use_extended_paths = true
            extended_paths = merge(
              var.rate_limit.enabled ? {
                rate_limit = [{
                  path   = "/"
                  method = ""
                  rate   = var.rate_limit.rate
                  per    = var.rate_limit.per
                }]
              } : {},
              var.quota.enabled ? {
                quota = [{
                  path         = "/"
                  method       = ""
                  quota_max    = var.quota.rate
                  quota_renews = var.quota.per
                }]
              } : {}
            )
          }
        }
      }
      proxy = {
        listen_path       = "/api-${i}/"
        target_url        = "http://fortio-${i % var.service.host_count}.tyk-upstream.svc:8080/"
        strip_listen_path = false
      }
      active                         = true
      global_headers                 = var.header_injection.req.enabled ? { "X-API-REQ" : "Foo" } : {}
      global_headers_remove          = []
      global_response_headers        = var.header_injection.res.enabled ? { "X-API-RES" : "Bar" } : {}
      global_response_headers_remove = []
      }, local.enable_jwt ? {
      enable_jwt              = true
      jwt_signing_method      = var.auth.type == "JWT-HMAC" ? "hmac" : "rsa"
      jwt_source              = local.jwt_source
      jwt_identity_base_field = "sub"
      jwt_policy_field_name   = "pol"
      jwt_default_policies    = ["policy-${i % var.service.app_count}"]
    } : {}))
  }

  # Generate policy definitions when auth/rate limiting/quota is enabled
  policy_definitions = (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? {
    for i in range(var.service.app_count) :
    "policy-${i}.json" => jsonencode({
      _id          = "policy-${i}"
      id           = "policy-${i}"
      name         = "policy-${i}"
      org_id       = "1"
      rate         = var.rate_limit.enabled ? var.rate_limit.rate : 0
      per          = var.rate_limit.enabled ? var.rate_limit.per : 0
      quota_max    = var.quota.enabled ? var.quota.rate : 0
      quota_renews = var.quota.enabled ? var.quota.per : 0
      access_rights = {
        for j in range(var.service.route_count) :
        "api-${j}" => {
          api_name = "api-${j}"
          api_id   = "api-${j}"
          versions = ["Default"]
        }
      }
      active = true
      tags   = ["Default"]
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

# Note: Shared storage resources removed - using ConfigMaps instead
# ConfigMaps provide a simpler, more reliable solution for mounting
# API definitions to all pods without requiring special storage classes