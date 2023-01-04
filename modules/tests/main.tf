provider "helm" {
  kubernetes {
    host                   = var.kubernetes.host
    username               = var.kubernetes.username
    password               = var.kubernetes.password
    token                  = var.kubernetes.token
    client_key             = var.kubernetes.client_key
    client_certificate     = var.kubernetes.client_certificate
    cluster_ca_certificate = var.kubernetes.cluster_ca_certificate
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
}

module "dependencies" {
  source = "../providers/dependencies"
}

module "tyk" {
  source = "../providers/tyk"
  count  = var.enable_tyk == true ? 1 : 0
}

module "kong" {
  source = "../providers/kong"
  count  = var.enable_kong == true ? 1 : 0
}

module "gravitee" {
  source = "../providers/gravitee"
  count  = var.enable_gravitee == true ? 1 : 0
}