locals {
  labels = var.node_labels == null ? module.deployments.labels : var.node_labels
}
