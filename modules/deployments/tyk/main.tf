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
    name  = "gateway.nodeSelector.node"
    value = var.label
  }

  depends_on = [helm_release.tyk-redis]
}
