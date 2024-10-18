## Azure Kubernetes Service

AKS setup requires the `az login` check out the [Terraform AKS documentation](https://developer.hashicorp.com/terraform/tutorials/kubernetes/aks#prerequisites).

## Connect to Cluster
```
az aks get-credentials \
   --resource-group "pt-westus" \
   --name "pt-westus"
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|------|:--------:|
| <a name="input_aks_version"></a> [aks\_version](#input\_aks\_version) | AKS cluster version. | `string` | `""` | no |
| <a name="input_cluster_location"></a> [cluster\_location](#input\_cluster\_location) | AKS cluster location. | `string` | `"westus"` | no |
| <a name="input_cluster_machine_type"></a> [cluster\_machine\_type](#input\_cluster\_machine\_type) | Default machine type for cluster. | `string` | `"Standard_F4s_v2"` | no |
| <a name="input_dependencies_machine_type"></a> [dependencies\_machine\_type](#input\_dependencies\_machine\_type) | Machine type for dependencies, overrides cluster\_machine\_type. | `string` | `""` | no |
| <a name="input_dependencies_nodes_count"></a> [dependencies\_nodes\_count](#input\_dependencies\_nodes\_count) | Number of nodes for the test dependencies. | `number` | `1` | no |
| <a name="input_gravitee_enabled"></a> [gravitee\_enabled](#input\_gravitee\_enabled) | Enable Gravitee services. | `bool` | `false` | no |
| <a name="input_kong_enabled"></a> [kong\_enabled](#input\_kong\_enabled) | Enable Kong services. | `bool` | `false` | no |
| <a name="input_resource_nodes_count"></a> [resource\_nodes\_count](#input\_resource\_nodes\_count) | Number of nodes for each of the gateway resources. | `number` | `1` | no |
| <a name="input_resources_machine_type"></a> [resources\_machine\_type](#input\_resources\_machine\_type) | Machine type for resources, overrides cluster\_machine\_type. | `string` | `""` | no |
| <a name="input_service_machine_type"></a> [service\_machine\_type](#input\_service\_machine\_type) | Machine type for services, overrides cluster\_machine\_type. | `string` | `""` | no |
| <a name="input_services_nodes_count"></a> [services\_nodes\_count](#input\_services\_nodes\_count) | Number of nodes for each of the gateway services. | `number` | `1` | no |
| <a name="input_tests_machine_type"></a> [tests\_machine\_type](#input\_tests\_machine\_type) | Machine type for tests, overrides cluster\_machine\_type. | `string` | `""` | no |
| <a name="input_tests_nodes_count"></a> [tests\_nodes\_count](#input\_tests\_nodes\_count) | Number of nodes for each of the tests services. | `number` | `1` | no |
| <a name="input_tyk_enabled"></a> [tyk\_enabled](#input\_tyk\_enabled) | Enable Tyk services. | `bool` | `true` | no |
| <a name="input_upstream_machine_type"></a> [upstream\_machine\_type](#input\_upstream\_machine\_type) | Machine type for upstreams, overrides cluster\_machine\_type. | `string` | `""` | no |
| <a name="input_upstream_nodes_count"></a> [upstream\_nodes\_count](#input\_upstream\_nodes\_count) | Number of nodes for each of the upstream services. | `number` | `1` | no |
