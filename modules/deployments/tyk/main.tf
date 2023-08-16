terraform {
  required_providers {
    kubectl = {
      source = "alekc/kubectl"
      version = ">= 2.0.2"
    }
  }
}

resource "kubernetes_namespace" "tyk" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "tyk" {
  name       = "tyk-gateway"
  repository = "https://helm.tyk.io/public/helm/charts"
  chart      = "tyk-oss"

  namespace = var.namespace
  atomic    = true

  set {
    name  = "global.redis.addrs[0]"
    value = "tyk-redis-master.${var.namespace}.svc:6379"
  }

  set {
    name  = "global.redis.pass"
    value = "topsecretpassword"
  }

  set {
    name  = "tyk-gateway.gateway.image.tag"
    value = var.gateway_version
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[0].name"
    value = "TYK_GW_OPENTELEMETRY_ENABLED"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[0].value"
    type  = "string"
    value = var.oTel.enabled
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[1].name"
    value = "TYK_GW_OPENTELEMETRY_SAMPLING_TYPE"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[1].value"
    value = "TraceIDRatioBased"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[2].name"
    value = "TYK_GW_OPENTELEMETRY_SAMPLING_RATIO"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[2].value"
    type  = "string"
    value = var.oTel.sampling_ratio
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[3].name"
    value = "TYK_GW_OPENTELEMETRY_EXPORTER"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[3].value"
    value = "grpc"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[4].name"
    value = "TYK_GW_OPENTELEMETRY_ENDPOINT"
  }

  set {
    name  = "tyk-gateway.gateway.extraEnvs[4].value"
    value = "opentelemetry-collector.dependencies.svc:4317"
  }

  set {
    name  = "tyk-gateway.gateway.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "global.components.pump"
    value = var.analytics
  }

  set {
    name  = "tyk-pump.pump.nodeSelector.node"
    value = var.resources-label
  }

  depends_on = [helm_release.tyk-redis]
}
