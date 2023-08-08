resource "kubernetes_namespace" "upstream" {
  metadata {
    name = var.namespace
  }
}

module "httpbin" {
  source        = "./httpbin"
  namespace     = var.namespace
  node_selector = var.label
  count         = var.enable_httpbin ? 1 : 0
  depends_on    = [kubernetes_namespace.upstream]
}

module "timestamp" {
  source        = "./timestamp"
  namespace     = var.namespace
  node_selector = var.label
  count         = var.enable_timestamp ? 1 : 0
  depends_on    = [kubernetes_namespace.upstream]
}