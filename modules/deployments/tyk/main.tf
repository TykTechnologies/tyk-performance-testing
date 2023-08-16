terraform {
  required_providers {
    kubectl = {
      source = "alekc/kubectl"
      version = ">= 2.0.2"
    }
  }
}

resource "helm_release" "tyk" {
  name       = "tyk"
  repository = "https://helm.tyk.io/public/helm/charts"
  chart      = "tyk-headless"

  namespace = var.namespace
  atomic    = true

  set {
    name  = "gateway.image.tag"
    value = var.gateway_version
  }

  set {
    name  = "gateway.kind"
    value = "DaemonSet"
  }

  set {
    name  = "redis.addrs[0]"
    value = "tyk-redis-master.${var.namespace}.svc:6379"
  }

  set {
    name  = "redis.pass"
    value = "topsecretpassword"
  }

  set {
    name  = "gateway.extraEnvs[0].name"
    value = "TYK_GW_OPENTELEMETRY_ENABLED"
  }

  set {
    name  = "gateway.extraEnvs[0].value"
    type  = "string"
    value = var.oTel.enabled
  }

  set {
    name  = "gateway.extraEnvs[1].name"
    value = "TYK_GW_OPENTELEMETRY_SAMPLING_TYPE"
  }

  set {
    name  = "gateway.extraEnvs[1].value"
    value = "TraceIDRatioBased"
  }

  set {
    name  = "gateway.extraEnvs[2].name"
    value = "TYK_GW_OPENTELEMETRY_SAMPLING_RATIO"
  }

  set {
    name  = "gateway.extraEnvs[2].value"
    type  = "string"
    value = var.oTel.sampling_ratio
  }

  set {
    name  = "gateway.extraEnvs[3].name"
    value = "TYK_GW_OPENTELEMETRY_EXPORTER"
  }

  set {
    name  = "gateway.extraEnvs[3].value"
    value = "grpc"
  }

  set {
    name  = "gateway.extraEnvs[4].name"
    value = "TYK_GW_OPENTELEMETRY_ENDPOINT"
  }

  set {
    name  = "gateway.extraEnvs[4].value"
    value = "opentelemetry-collector.dependencies.svc:4317"
  }

  set {
    name  = "gateway.nodeSelector.node"
    value = var.label
  }

  depends_on = [helm_release.tyk-redis]
}
