resource "kubernetes_namespace" "upstream" {
  metadata {
    name = var.namespace
  }
}

module "timestamp" {
  source        = "./timestamp"
  namespace     = var.namespace
  node_selector = var.label
  depends_on    = [kubernetes_namespace.upstream]
}
