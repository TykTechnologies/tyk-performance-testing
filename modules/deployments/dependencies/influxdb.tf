resource "helm_release" "influxdb" {
  name       = "influxdb"
  repository = "https://helm.influxdata.com/"
  chart      = "influxdb2"
  version    = "2.1.2"

  namespace = var.namespace
  atomic    = true

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.size"
    value = "10Gi"
  }

  set {
    name  = "nodeSelector.node"
    value = var.label
  }

  depends_on = [kubernetes_namespace.dependencies]
}

# Create a ConfigMap with InfluxDB connection info
resource "kubernetes_config_map" "influxdb_config" {
  metadata {
    name      = "influxdb-config"
    namespace = var.namespace
  }

  data = {
    url = "http://influxdb-influxdb2.${var.namespace}.svc:8086"
    org = "k6"
    bucket = "k6"
    token = "mytoken" # In production, use a secret
  }

  depends_on = [helm_release.influxdb]
}