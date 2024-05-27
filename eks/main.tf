provider "aws" {
  region = var.cluster_location
}

data "aws_availability_zones" "this" {}

module "h" {
  source = "../modules/helpers"

  services_nodes_count      = var.services_nodes_count
  resource_nodes_count      = var.resource_nodes_count
  dependencies_nodes_count  = var.dependencies_nodes_count
  cluster_machine_type      = var.cluster_machine_type
  service_machine_type      = var.service_machine_type
  upstream_machine_type     = var.upstream_machine_type
  tests_machine_type        = var.tests_machine_type
  resources_machine_type    = var.resources_machine_type
  dependencies_machine_type = var.dependencies_machine_type

  tyk_enabled      = var.tyk_enabled
  kong_enabled     = var.kong_enabled
  gravitee_enabled = var.gravitee_enabled
}

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

  cluster_name    = "pt-${var.cluster_location}"
  cluster_version = var.eks_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true
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
  instance_types  = [module.h.machines[each.key]]

  labels = {
    "node": each.key
  }
}

module "ebs_csi_controller_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  create_role                   = true
  role_name                     = "${module.eks.cluster_name}-ebs-csi-controller"
  provider_url                  = module.eks.cluster_oidc_issuer_url
  role_policy_arns              = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "this" {
  cluster_name                = module.eks.cluster_name
  addon_name                  = "aws-ebs-csi-driver"
  resolve_conflicts_on_create = "OVERWRITE"
  service_account_role_arn    = module.ebs_csi_controller_role.iam_role_arn
  depends_on                  = [module.eks, module.eks_node_groups]
}
