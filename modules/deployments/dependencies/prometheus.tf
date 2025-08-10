resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "23.3.0"

  namespace = var.namespace
  atomic    = true
  timeout   = 900  # 15 minutes (increased for AWS EKS)

  set {
    name  = "server.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "server.extraFlags[0]"
    value = "web.enable-remote-write-receiver"
  }

  set {
    name  = "server.extraArgs.enable-feature"
    value = "native-histograms"
  }

  set {
    name  = "alertmanager.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "kube-state-metrics.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "prometheus-pushgateway.nodeSelector.node"
    value = var.label
  }

  set {
    name  = "kube-state-metrics.extraArgs[0]"
    value = "--metric-labels-allowlist=nodes=[*]"
  }

  # Reduce resource requirements for better AWS EKS compatibility
  set {
    name  = "server.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "server.resources.requests.memory"
    value = "256Mi"
  }

  set {
    name  = "server.resources.limits.cpu"
    value = "500m"
  }

  set {
    name  = "server.resources.limits.memory"
    value = "512Mi"
  }

  set {
    name  = "alertmanager.resources.requests.cpu"
    value = "50m"
  }

  set {
    name  = "alertmanager.resources.requests.memory"
    value = "64Mi"
  }

  depends_on = [kubernetes_namespace.dependencies]
}