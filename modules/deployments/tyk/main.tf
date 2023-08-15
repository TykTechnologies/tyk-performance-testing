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
    value = "v5.2.0-rc1"
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
    value = var.enable_oTel
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
    value = var.oTel_sampling_ratio
  }

  set {
    name  = "gateway.nodeSelector.node"
    value = var.label
  }

  depends_on = [helm_release.tyk-redis]
}
