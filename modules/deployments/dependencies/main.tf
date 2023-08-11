resource "kubernetes_namespace" "dependencies" {
  metadata {
    name = "dependencies"
  }
}
