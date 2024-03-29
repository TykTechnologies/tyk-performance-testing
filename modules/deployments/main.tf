module "dependencies" {
  source = "./dependencies"

  label       = var.labels.dependencies
  oTelEnabled = var.oTel.enabled
}

module "tyk-upstream" {
  source    = "./upstream"
  label     = var.labels.tyk-upstream
  namespace = var.labels.tyk-upstream

  enable_timestamp              = var.tests.timestamp
  enable_httpbin                = var.tests.httpbin
  enable_users_rest             = false
  enable_posts_rest             = false
  enable_comments_rest          = false
  enable_users_graphql          = false
  enable_posts_graphql          = false
  enable_comments_graphql       = false
  enable_notifications_graphql  = false
  enable_users_subgraph         = false
  enable_posts_subgraph         = false
  enable_comments_subgraph      = false
  enable_notifications_subgraph = false

  count = var.tyk.enabled == true ? 1 : 0
}

module "kong-upstream" {
  source = "./upstream"
  label     = var.labels.kong-upstream
  namespace = var.labels.kong-upstream

  enable_timestamp              = var.tests.timestamp
  enable_httpbin                = var.tests.httpbin
  enable_users_rest             = false
  enable_posts_rest             = false
  enable_comments_rest          = false
  enable_users_graphql          = false
  enable_posts_graphql          = false
  enable_comments_graphql       = false
  enable_notifications_graphql  = false
  enable_users_subgraph         = false
  enable_posts_subgraph         = false
  enable_comments_subgraph      = false
  enable_notifications_subgraph = false

  count = var.kong.enabled == true ? 1 : 0
}

module "gravitee-upstream" {
  source = "./upstream"
  label     = var.labels.gravitee-upstream
  namespace = var.labels.gravitee-upstream

  enable_timestamp              = var.tests.timestamp
  enable_httpbin                = var.tests.httpbin
  enable_users_rest             = false
  enable_posts_rest             = false
  enable_comments_rest          = false
  enable_users_graphql          = false
  enable_posts_graphql          = false
  enable_comments_graphql       = false
  enable_notifications_graphql  = false
  enable_users_subgraph         = false
  enable_posts_subgraph         = false
  enable_comments_subgraph      = false
  enable_notifications_subgraph = false

  count = var.gravitee.enabled == true ? 1 : 0
}

module "tyk" {
  source = "./tyk"

  label           = var.labels.tyk
  resources-label = var.labels.tyk-resources

  gateway_version = var.tyk.version

  deployment_type = var.deployment_type
  replica_count   = var.replica_count
  resources       = var.resources
  go_gc           = var.go_gc
  go_max_procs    = var.go_max_procs

  analytics    = var.analytics
  auth         = var.auth
  oTel         = var.oTel
  quota        = var.quota
  rateLimiting = var.rateLimiting

  count = var.tyk.enabled == true ? 1 : 0
  depends_on = [module.dependencies]
}

module "kong" {
  source          = "./kong"
  label           = var.labels.kong
  resources-label = var.labels.kong-resources

  gateway_version = var.kong.version

  deployment_type = var.deployment_type
  replica_count   = var.replica_count
  resources       = var.resources

  analytics    = var.analytics
  auth         = var.auth
  oTel         = var.oTel
  quota        = var.quota
  rateLimiting = var.rateLimiting

  count = var.kong.enabled == true ? 1 : 0
  depends_on = [module.dependencies]
}

module "gravitee" {
  source          = "./gravitee"
  label           = var.labels.gravitee
  resources-label = var.labels.gravitee-resources

  gateway_version = var.gravitee.version

  deployment_type = var.deployment_type
  replica_count   = var.replica_count
  resources       = var.resources

  analytics    = var.analytics
  auth         = var.auth
  oTel         = var.oTel
  quota        = var.quota
  rateLimiting = var.rateLimiting

  count = var.gravitee.enabled == true ? 1 : 0
  depends_on = [module.dependencies]
}
