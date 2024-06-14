terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.4"
    }
  }
}

locals {
  redis-pass = "topsecretpassword"
  redis-port = "6379"
}

resource "kubernetes_namespace" "kong" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "kong" {
  name       = "kong"
  repository = "https://charts.konghq.com"
  chart      = "ingress"
  version    = "0.13.0"

  namespace = var.namespace
  atomic    = true

  set {
    name  = "gateway.image.tag"
    value = var.gateway_version
  }

  #############################################################################
  # Performance
  #############################################################################

  set {
    name  = "gateway.env.nginx_worker_processes"
    value = "auto"
  }

  set {
    name  = "gateway.env.nginx_main_worker_rlimit_nofile"
    value = "auto"
  }

  set {
    name  = "gateway.env.nginx_events_worker_connections"
    value = "auto"
  }

  set {
    name  = "gateway.deployment.daemonset"
    value = var.deployment_type == "DaemonSet" ? true : false
  }

  set {
    name  = "gateway.replicaCount"
    value = var.replica_count
  }

  set {
    name  = "gateway.resources.requests.cpu"
    value = var.resources.requests.cpu
  }

  set {
    name  = "gateway.resources.requests.memory"
    value = var.resources.requests.memory
  }

  set {
    name  = "gateway.resources.limits.cpu"
    value = var.resources.limits.cpu
  }

  set {
    name  = "gateway.resources.limits.memory"
    value = var.resources.limits.memory
  }

  #############################################################################
  # Database
  #############################################################################

  set {
    name  = "gateway.postgresql.enabled"
    value = "true"
  }

  set {
    name  = "gateway.env.database"
    value = "postgres"
  }

  #############################################################################
  # Kong services
  #############################################################################

  set {
    name  = "gateway.proxy.type"
    value = "ClusterIP"
  }

  set {
    name  = "gateway.admin.enabled"
    value = "true"
  }

  set {
    name  = "gateway.admin.type"
    value = "ClusterIP"
  }

  set {
    name  = "gateway.ingressController.enabled"
    value = "false"
  }

  set {
    name  = "gateway.portal.enabled"
    value = "false"
  }

  set {
    name  = "gateway.portalapi.enabled"
    value = "false"
  }

  set {
    name  = "gateway.nodeSelector.node"
    value = var.label
  }

  depends_on = [helm_release.kong-redis, kubectl_manifest.kong_gateway]
}
