resource "kubernetes_namespace" "upstream" {
  metadata {
    name = var.namespace
  }
}

module "timestamp" {
  source        = "./timestamp"
  namespace     = var.namespace
  node_selector = var.label
  count         = var.enable_timestamp ? 1 : 0
  depends_on    = [kubernetes_namespace.upstream]
}

module "httpbin" {
  source        = "./httpbin"
  namespace     = var.namespace
  node_selector = var.label
  count         = var.enable_httpbin ? 1 : 0
  depends_on    = [kubernetes_namespace.upstream]
}

module "users-rest" {
  source        = "./users-rest"
  namespace     = var.namespace
  node_selector = var.label
  count         = var.enable_users_rest ? 1 : 0
  depends_on    = [kubernetes_namespace.upstream]
}

module "posts-rest" {
  source        = "./posts-rest"
  namespace     = var.namespace
  node_selector = var.label
  count         = var.enable_posts_rest ? 1 : 0
  depends_on    = [kubernetes_namespace.upstream]
}

module "comments-rest" {
  source        = "./comments-rest"
  namespace     = var.namespace
  node_selector = var.label
  count         = var.enable_comments_rest ? 1 : 0
  depends_on    = [kubernetes_namespace.upstream]
}

module "users-graphql" {
  source        = "./users-graphql"
  namespace     = var.namespace
  node_selector = var.label
  count         = var.enable_users_graphql ? 1 : 0
  depends_on    = [kubernetes_namespace.upstream]
}

module "posts-graphql" {
  source        = "./posts-graphql"
  namespace     = var.namespace
  node_selector = var.label
  count         = var.enable_posts_graphql ? 1 : 0
  depends_on    = [kubernetes_namespace.upstream]
}

module "comments-graphql" {
  source        = "./comments-graphql"
  namespace     = var.namespace
  node_selector = var.label
  count         = var.enable_comments_graphql ? 1 : 0
  depends_on    = [kubernetes_namespace.upstream]
}

module "notifications-graphql" {
  source        = "./notifications-graphql"
  namespace     = var.namespace
  node_selector = var.label
  count         = var.enable_notifications_graphql ? 1 : 0
  depends_on    = [kubernetes_namespace.upstream]
}

module "users-subgraph" {
  source        = "./users-subgraph"
  namespace     = var.namespace
  node_selector = var.label
  count         = var.enable_users_subgraph ? 1 : 0
  depends_on    = [kubernetes_namespace.upstream]
}

module "posts-subgraph" {
  source        = "./posts-subgraph"
  namespace     = var.namespace
  node_selector = var.label
  count         = var.enable_posts_subgraph ? 1 : 0
  depends_on    = [kubernetes_namespace.upstream]
}

module "comments-subgraph" {
  source        = "./comments-subgraph"
  namespace     = var.namespace
  node_selector = var.label
  count         = var.enable_comments_subgraph ? 1 : 0
  depends_on    = [kubernetes_namespace.upstream]
}

module "notifications-subgraph" {
  source        = "./notifications-subgraph"
  namespace     = var.namespace
  node_selector = var.label
  count         = var.enable_notifications_subgraph ? 1 : 0
  depends_on    = [kubernetes_namespace.upstream]
}