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
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "pt-${var.cluster_location}"
  cluster_version = "1.22"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true
}

module "eks_node_groups" {
  for_each = var.nodes
  source   = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

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

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name

  depends_on = [module.eks, module.eks_node_groups]
}

output "kubernetes" {
  value = {
    host                   = module.eks.cluster_endpoint
    username               = null
    password               = null
    token                  = data.aws_eks_cluster_auth.this.token
    client_key             = null
    client_certificate     = null
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    config_path            = null
    config_context         = null
  }

  depends_on = [module.eks, module.eks_node_groups]
}
