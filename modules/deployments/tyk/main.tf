terraform {
  required_providers {
    kubectl = {
      source = "alekc/kubectl"
      version = ">= 2.0.2"
    }
  }
}

locals {
  redis-pass = "topsecretpassword"
  redis-port = "6379"
}

resource "helm_release" "tyk" {
  name       = "tyk-gateway"
  repository = "https://helm.tyk.io/public/helm/charts"
  chart      = "tyk-oss"

  namespace        = var.namespace
  create_namespace = true
  atomic           = true

  set {
    name  = "global.redis.addrs[0]"
    value = "${helm_release.tyk-redis.name}-master.${var.namespace}.svc:${local.redis-port}"
  }

  set {
    name  = "global.redis.pass"
    value = local.redis-pass
  }

  set {
    name  = "tyk-gateway.gateway.image.tag"
    value = var.gateway_version
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[0].name"
    value = "GOGC"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[0].value"
    type  = "string"
    value = "1600"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[1].name"
    value = "TYK_GW_OPENTELEMETRY_ENABLED"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[1].value"
    type  = "string"
    value = var.oTel.enabled
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[2].name"
    value = "TYK_GW_OPENTELEMETRY_SAMPLING_TYPE"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[2].value"
    value = "TraceIDRatioBased"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[3].name"
    value = "TYK_GW_OPENTELEMETRY_SAMPLING_RATIO"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[3].value"
    type  = "string"
    value = var.oTel.sampling_ratio
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[4].name"
    value = "TYK_GW_OPENTELEMETRY_EXPORTER"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[4].value"
    value = "grpc"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[5].name"
    value = "TYK_GW_OPENTELEMETRY_ENDPOINT"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[5].value"
    value = "opentelemetry-collector.dependencies.svc:4317"
  }

  set {
    name  = "tyk-gateway.gateway.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "global.components.pump"
    value = var.analytics.enabled
  }

  set {
    name  = "tyk-pump.pump.nodeSelector.node"
    value = var.resources-label
  }

  depends_on = [helm_release.tyk-redis]
}
