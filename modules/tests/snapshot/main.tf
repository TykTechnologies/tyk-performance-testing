terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.4"
    }
  }
}

locals {
  delay = var.duration * 60
}

resource "kubernetes_job" "snapshot_job" {
  metadata {
    name      = "snapshot-job-${var.name}"
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
            value = var.duration
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

  wait_for_completion = false
}
