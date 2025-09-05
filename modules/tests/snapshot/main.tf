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
  # For segmented tests (duration > 60), add extra time for segments to complete sequentially
  # Each 60-min segment takes ~75 min (with overhead), so total time is roughly duration * 1.25
  actual_runtime = var.duration > 60 ? ceil(var.duration * 1.25) : var.duration
  delay     = (local.actual_runtime + local.buffer) * 60
  # Timeout needs to cover: delay time + snapshot generation time + buffer
  # delay is in seconds, but timeout is in minutes
  # So: (actual_runtime + buffer) for the delay, plus 20 minutes for snapshot generation
  timeout   = (local.actual_runtime + local.buffer + 20)
  timestamp = formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())
}

resource "kubernetes_job" "snapshot_job" {
  metadata {
    name      = "snapshot-job-${var.name}-${local.timestamp}"
    namespace = "dependencies"
  }
  
  wait_for_completion = false  # Don't block terraform - run snapshot job in background

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

  # No timeout needed since we don't wait for completion
}
