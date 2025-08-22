terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.4"
    }
  }
}

locals {
  buffer    = var.duration <= 20 ? 4 : 10
  delay     = (var.duration + local.buffer) * 60
  # Timeout needs to cover: delay time + snapshot generation time + buffer
  # delay is in seconds, but timeout is in minutes
  # So: (duration + buffer) for the delay, plus 20 minutes for snapshot generation
  timeout   = (var.duration + local.buffer + 20)
  timestamp = formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())
}

resource "kubernetes_job" "snapshot_job" {
  metadata {
    name      = "snapshot-job-${var.name}-${local.timestamp}"
    namespace = "dependencies"
  }

  spec {
    template {
      metadata {
        labels = {
          app = "snapshot-job"
        }
      }

      spec {
        container {
          name    = "snapshot-container"
          image   = "python:3.9"
          command = ["bash", "-c", "pip install selenium && sleep ${local.delay} && python /scripts/snapshot.py"]

          volume_mount {
            name       = "script-volume"
            mount_path = "/scripts"
          }

          env {
            name  = "TEST_DURATION"
            value = var.duration + (local.buffer * 2)
          }
        }

        volume {
          name = "script-volume"

          config_map {
            name = "snapshot-script-configmap"

            items {
              key  = "snapshot.py"
              path = "snapshot.py"
            }
          }
        }

        node_selector = {
          node = "dependencies"
        }

        restart_policy = "Never"
      }
    }
  }

  timeouts {
    create = "${local.timeout}m"
  }
}
