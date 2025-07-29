locals {
  grafana = {
    username = "admin"
    password = "topsecretpassword"
  }
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "v7.3.9"

  namespace = var.namespace
  atomic    = true

  set {
    name  = "adminPassword"
    value = local.grafana.password
  }

  set {
    name  = "service.type"
    value = var.grafana.service.type
  }

  set {
    name  = "datasources.datasources\\.yaml.apiVersion"
    value = "1"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].name"
    value = "Prometheus"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].type"
    value = "prometheus"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].url"
    value = "http://prometheus-server.dependencies.svc"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].access"
    value = "proxy"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].isDefault"
    value = "true"
  }

  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.apiVersion"
    value = "1"
  }

  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.providers[0].name"
    value = "Tyk"
  }

  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.providers[0].orgId"
    value = "1"
  }

  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.providers[0].type"
    value = "file"
  }

  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.providers[0].disableDeletion"
    value = "false"
  }

  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.providers[0].editable"
    value = "true"
  }

  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.providers[0].updateIntervalSeconds"
    value = "10"
  }

  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.providers[0].options.path"
    value = "/etc/tyk-grafana/provisioning/dashboards"
  }

  set {
    name  = "extraConfigmapMounts[0].name"
    value = "grafana-dashboards"
  }

  set {
    name  = "extraConfigmapMounts[0].mountPath"
    value = "/etc/tyk-grafana/provisioning/dashboards/dashboards.json"
  }

  set {
    name  = "extraConfigmapMounts[0].subPath"
    value = "dashboards.json"
  }

  set {
    name  = "extraConfigmapMounts[0].configMap"
    value = "grafana-dashboards-configmap"
  }

  set {
    name  = "extraConfigmapMounts[0].readOnly"
    value = "true"
  }

  set {
    name  = "nodeSelector.node"
    value = var.label
  }

  set {
    name  = "env.JAEGER_AGENT_PORT"
    value = ""
  }

  depends_on = [kubernetes_namespace.dependencies, kubernetes_config_map.grafana-dashboard]
}

