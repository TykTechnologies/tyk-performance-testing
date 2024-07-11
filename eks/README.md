## Elastic Kubernetes Service

## Connect to Cluster
```
aws eks --region "us-west-1" update-kubeconfig --name "pt-us-west-1"
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.51.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ebs_csi_controller_role"></a> [ebs\_csi\_controller\_role](#module\_ebs\_csi\_controller\_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 20.8.2 |
| <a name="module_eks_node_groups"></a> [eks\_node\_groups](#module\_eks\_node\_groups) | terraform-aws-modules/eks/aws//modules/eks-managed-node-group | 20.8.2 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_availability_zones.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_location"></a> [cluster\_location](#input\_cluster\_location) | EKS cluster location. | `string` | `"us-west-1"` | no |
| <a name="input_cluster_machine_type"></a> [cluster\_machine\_type](#input\_cluster\_machine\_type) | Default machine type for cluster. | `string` | `"c5.xlarge"` | no |
| <a name="input_dependencies_machine_type"></a> [dependencies\_machine\_type](#input\_dependencies\_machine\_type) | Machine type for dependencies, overrides cluster\_machine\_type. | `string` | `""` | no |
| <a name="input_dependencies_nodes_count"></a> [dependencies\_nodes\_count](#input\_dependencies\_nodes\_count) | Number of nodes for the test dependencies. | `number` | `1` | no |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | EKS cluster version. | `string` | `"1.29"` | no |
| <a name="input_gravitee_enabled"></a> [gravitee\_enabled](#input\_gravitee\_enabled) | Enable Gravitee services. | `bool` | `false` | no |
| <a name="input_kong_enabled"></a> [kong\_enabled](#input\_kong\_enabled) | Enable Kong services. | `bool` | `false` | no |
| <a name="input_resource_nodes_count"></a> [resource\_nodes\_count](#input\_resource\_nodes\_count) | Number of nodes for each of the gateway resources. | `number` | `1` | no |
| <a name="input_resources_machine_type"></a> [resources\_machine\_type](#input\_resources\_machine\_type) | Machine type for resources, overrides cluster\_machine\_type. | `string` | `""` | no |
| <a name="input_service_machine_type"></a> [service\_machine\_type](#input\_service\_machine\_type) | Machine type for services, overrides cluster\_machine\_type. | `string` | `""` | no |
| <a name="input_services_nodes_count"></a> [services\_nodes\_count](#input\_services\_nodes\_count) | Number of nodes for each of the gateway services. | `number` | `1` | no |
| <a name="input_upstream_nodes_count"></a> [upstream\_nodes\_count](#input\_upstream\_nodes\_count) | Number of nodes for each of the upstream services. | `number` | `1` | no |
| <a name="input_tests_nodes_count"></a> [tests\_nodes\_count](#input\_tests\_nodes\_count) | Number of nodes for each of the tests services. | `number` | `1` | no |
| <a name="input_tests_machine_type"></a> [tests\_machine\_type](#input\_tests\_machine\_type) | Machine type for tests, overrides cluster\_machine\_type. | `string` | `""` | no |
| <a name="input_tyk_enabled"></a> [tyk\_enabled](#input\_tyk\_enabled) | Enable Tyk services. | `bool` | `true` | no |
| <a name="input_upstream_machine_type"></a> [upstream\_machine\_type](#input\_upstream\_machine\_type) | Machine type for upstreams, overrides cluster\_machine\_type. | `string` | `""` | no |
