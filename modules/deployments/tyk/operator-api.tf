resource "kubernetes_config_map" "api" {
  metadata {
    name      = "api"
    namespace = var.namespace
    annotations = {
      pt-annotations-auth: "${var.auth.enabled}"
      pt-annotations-rate-limiting: "${var.rate_limit.enabled}"
      pt-annotations-quota: "${var.quota.enabled}"
      pt-annotations-open-telemetry: "${var.open_telemetry.enabled}"
      pt-annotations-analytics-database: "${var.analytics.database.enabled}"
      pt-annotations-analytics-prometheus: "${var.analytics.prometheus.enabled}"
      pt-annotations-req-header-injection: "${var.header_injection.req.enabled}"
      pt-annotations-res-header-injection: "${var.header_injection.res.enabled}"
    }
  }

  data = {
    "api.json" = <<EOF
{
  "info": {
    "title": "api",
    "version": "1.0.0"
  },
  "openapi": "3.0.3",
  "servers": [
    {
      "url": "http://tyk-gw.local/api/"
    }
  ],
  "security": [
    {
      "jwtAuth": []
    }
  ],
  "paths": {},
  "components": {
    "securitySchemes": {
      "jwtAuth": {
        "type": "http",
        "scheme": "bearer",
        "bearerFormat": "JWT"
      },
      "authToken": {
        "type": "apiKey",
        "in": "header",
        "name": "Authorization"
      }
    }
  },
  "x-tyk-api-gateway": {
    "info": {
      "name": "api",
      "state": {
        "active": true,
        "internal": false
      }
    },
    "middleware": {
      "global": {
        "contextVariables": {
          "enabled": false
        },
        "transformRequestHeaders": {
          "add": [ { "name": "X-API-REQ", "value": "Foo" } ],
          "enabled": ${var.header_injection.req.enabled},
          "remove": []
        },
        "transformResponseHeaders": {
          "add": [ { "name": "X-API-RES", "value": "Bar" } ],
          "enabled": ${var.header_injection.res.enabled},
          "remove": []
        }
      }
    },
    "server": {
      "authentication": {
        "enabled": ${var.auth.enabled || var.rate_limit.enabled || var.quota.enabled},
        "securitySchemes": {
          "authToken": {
            "enabled": ${var.auth.type == "authToken"}
          },
          "jwtAuth": {
            "header": {
              "enabled": true,
              "name": "Authorization"
            },
            "identityBaseField": "sub",
            "policyFieldName": "pol",
            "enabled": ${var.auth.type == "JWT-RSA" || var.auth.type == "JWT-HMAC"},
            "defaultPolicies": [ "dHlrL2FwaS1wb2xpY3k" ],
            "signingMethod": "${var.auth.type == "JWT-HMAC" ? "hmac" : "rsa"}",
            "source": "${var.auth.type == "JWT-HMAC" ? "dG9wc2VjcmV0cGFzc3dvcmQ=": "aHR0cDovL2tleWNsb2FrLXNlcnZpY2UuZGVwZW5kZW5jaWVzLnN2Yzo4MDgwL3JlYWxtcy9qd3QvcHJvdG9jb2wvb3BlbmlkLWNvbm5lY3QvY2VydHM="}"
          }
        }
      },
      "listenPath": {
        "strip": true,
        "value": "/api/"
      }
    },
    "upstream": {
      "url": "http://fortio.tyk-upstream.svc:8080"
    }
  }
}
EOF
  }
}

resource "kubectl_manifest" "api" {
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: TykOasApiDefinition
metadata:
  name: api
  namespace: ${var.namespace}
  annotations:
    pt-annotations-auth: "${var.auth.enabled}"
    pt-annotations-auth-type: "${var.auth.type}"
    pt-annotations-rate-limiting: "${var.rate_limit.enabled}"
    pt-annotations-quota: "${var.quota.enabled}"
    pt-annotations-open-telemetry: "${var.open_telemetry.enabled}"
    pt-annotations-analytics-database: "${var.analytics.database.enabled}"
    pt-annotations-analytics-prometheus: "${var.analytics.prometheus.enabled}"
    pt-annotations-req-header-injection: "${var.header_injection.req.enabled}"
    pt-annotations-res-header-injection: "${var.header_injection.res.enabled}"
spec:
  tykOAS:
    configmapRef:
      name: api
      namespace: ${var.namespace}
      keyName: api.json
YAML
  depends_on = [kubernetes_config_map.api, helm_release.tyk-operator]
}

resource "kubectl_manifest" "api-policy" {
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: SecurityPolicy
metadata:
  name: api-policy
  namespace: ${var.namespace}
  annotations:
    pt-annotations-auth: "${var.auth.enabled}"
    pt-annotations-auth-type: "${var.auth.type}"
    pt-annotations-rate-limiting: "${var.rate_limit.enabled}"
    pt-annotations-quota: "${var.quota.enabled}"
    pt-annotations-open-telemetry: "${var.open_telemetry.enabled}"
    pt-annotations-analytics-database: "${var.analytics.database.enabled}"
    pt-annotations-analytics-prometheus: "${var.analytics.prometheus.enabled}"
    pt-annotations-req-header-injection: "${var.header_injection.req.enabled}"
    pt-annotations-res-header-injection: "${var.header_injection.res.enabled}"
spec:
  name: api-policy
  state: active
  active: true
  quota_max: ${var.quota.enabled ? var.quota.rate : -1}
  quota_renewal_rate: ${var.quota.enabled ? var.quota.per : -1}
  rate: ${var.rate_limit.enabled ? var.rate_limit.rate : -1}
  per: ${var.rate_limit.enabled ? var.rate_limit.per : -1}
  throttle_interval: -1
  throttle_retry_limit: -1
  access_rights_array:
  - name: api
    namespace: ${var.namespace}
    kind: TykOasApiDefinition
    versions:
    - Default
YAML

  depends_on = [kubectl_manifest.api]
  count      = (var.auth.enabled || var.rate_limit.enabled || var.quota.enabled) ? 1 : 0
}
