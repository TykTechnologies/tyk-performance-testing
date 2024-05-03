provider "aws" {
  region = var.cluster_location
}

data "aws_availability_zones" "this" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "pt-${var.cluster_location}-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.this.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.2"

  cluster_name    = "pt-${replace(var.cluster_machine_type, ".", "-")}"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true
}

module "h" {
  source = "./modules"

  services_nodes_count      = var.services_nodes_count
  resource_nodes_count      = var.resource_nodes_count
  dependencies_nodes_count  = var.dependencies_nodes_count

  tyk_enabled      = var.tyk_enabled
  kong_enabled     = var.kong_enabled
  gravitee_enabled = var.gravitee_enabled
}

module "eks_node_groups" {
  for_each = module.h.nodes
  source   = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version  = "20.8.2"

  name            = each.key
  cluster_name    = module.eks.cluster_name
  cluster_version = module.eks.cluster_version
  subnet_ids      = module.vpc.private_subnets
  desired_size    = each.value
  instance_types  = [var.cluster_machine_type]

  labels = {
    "node": each.key
  }
}
