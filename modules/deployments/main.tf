provider "helm" {
  kubernetes {
    host                   = var.kubernetes.host
    username               = var.kubernetes.username
    password               = var.kubernetes.password
    token                  = var.kubernetes.token
    client_key             = var.kubernetes.client_key
    client_certificate     = var.kubernetes.client_certificate
    cluster_ca_certificate = var.kubernetes.cluster_ca_certificate
    config_path            = var.kubernetes.config_path
    config_context         = var.kubernetes.config_context
  }
}

provider "kubernetes" {
  host                   = var.kubernetes.host
  username               = var.kubernetes.username
  password               = var.kubernetes.password
  token                  = var.kubernetes.token
  client_key             = var.kubernetes.client_key
  client_certificate     = var.kubernetes.client_certificate
  cluster_ca_certificate = var.kubernetes.cluster_ca_certificate
  config_path            = var.kubernetes.config_path
  config_context         = var.kubernetes.config_context
}

module "k6-operator" {
  source = "./k6"
}

module "dependencies" {
  source = "./dependencies"
}

module "tyk" {
  source = "./tyk"
  count  = var.enable_tyk == true ? 1 : 0
}

module "kong" {
  source = "./kong"
  count  = var.enable_kong == true ? 1 : 0
}

module "gravitee" {
  source = "./gravitee"
  count  = var.enable_gravitee == true ? 1 : 0
}