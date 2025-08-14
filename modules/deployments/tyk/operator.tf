resource "helm_release" "tyk-operator" {
  count = var.use_config_maps_for_apis ? 0 : 1
  
  name       = "tyk-operator"
  repository = "https://helm.tyk.io/public/helm/charts/"
  chart      = "tyk-operator"

  namespace = var.namespace
  atomic    = true

  # GKE: cloud.google.com/gke-nodepool
  dynamic "set" {
    for_each = var.cluster_type == "gke" ? [1] : []
    content {
      name  = "nodeSelector.cloud\\.google\\.com/gke-nodepool"
      value = var.resources_label
    }
  }

  # AKS: agentpool
  dynamic "set" {
    for_each = var.cluster_type == "aks" ? [1] : []
    content {
      name  = "nodeSelector.agentpool"
      value = var.resources_label
    }
  }

  # EKS: eks.amazonaws.com/nodegroup
  dynamic "set" {
    for_each = var.cluster_type == "eks" ? [1] : []
    content {
      name  = "nodeSelector.eks\\.amazonaws\\.com/nodegroup"
      value = var.resources_label
    }
  }

  # Fallback: custom clusters
  dynamic "set" {
    for_each = contains(["gke","aks","eks"], var.cluster_type) == false ? [1] : []
    content {
      name  = "nodeSelector.node"
      value = var.resources_label
    }
  }

  depends_on = [kubernetes_namespace.tyk, helm_release.tyk]
}