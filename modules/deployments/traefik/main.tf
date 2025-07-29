terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.4"
    }
  }
}

resource "kubernetes_namespace" "traefik" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  version    = "34.4.1"

  namespace = var.namespace
  atomic    = true

  set = {
    name  = "image.tag"
    value = var.gateway_version
  }

  set = {
    name  = "deployment.kind"
    value = var.deployment_type
  }


  set = {
    name  = "service.type"
    value = var.service_type
  }

  set = {
    name  = "deployment.replicas"
    value = var.replica_count
  }

  set = {
    name  = "resources.requests.cpu"
    value = var.resources.requests.cpu
  }

  set = {
    name  = "resources.requests.memory"
    value = var.resources.requests.memory
  }

  set = {
    name  = "resources.limits.cpu"
    value = var.resources.limits.cpu
  }

  set = {
    name  = "resources.limits.memory"
    value = var.resources.limits.memory
  }

  set = {
    name  = "nodeSelector.node"
    value = var.label
  }

  set = {
    name  = var.analytics.prometheus.enabled ? "metrics.prometheus.entryPoint" : "metrics.prometheus"
    value = var.analytics.prometheus.enabled ? "metrics" : "null"
  }

  depends_on = [kubernetes_namespace.traefik]
}
