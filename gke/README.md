## Google Kubernetes Engine

GKE setup requires the `GOOGLE_APPLICATION_CREDENTIALS` per [google's documentation](https://cloud.google.com/docs/authentication/application-default-credentials).

## Connect to Cluster
```
gcloud container clusters get-credentials pt-us-west1-a \
   --zone us-west1-a \
   --project performance-testing
```

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_h"></a> [h](#module\_h) | ../modules/helpers | n/a |

## Resources

| Name | Type |
|------|------|
| [google_container_cluster.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_client_config.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_location"></a> [cluster\_location](#input\_cluster\_location) | GKE cluster location. | `string` | `"us-west1-a"` | no |
| <a name="input_cluster_machine_type"></a> [cluster\_machine\_type](#input\_cluster\_machine\_type) | Default machine type for cluster. | `string` | `"c2-standard-4"` | no |
| <a name="input_dependencies_machine_type"></a> [dependencies\_machine\_type](#input\_dependencies\_machine\_type) | Machine type for dependencies, overrides cluster\_machine\_type. | `string` | `""` | no |
| <a name="input_dependencies_nodes_count"></a> [dependencies\_nodes\_count](#input\_dependencies\_nodes\_count) | Number of nodes for the test dependencies. | `number` | `1` | no |
| <a name="input_gke_version"></a> [gke\_version](#input\_gke\_version) | GKE cluster version. | `string` | `"1.30.3-gke.1969002"` | no |
| <a name="input_gravitee_enabled"></a> [gravitee\_enabled](#input\_gravitee\_enabled) | Enable Gravitee services. | `bool` | `false` | no |
| <a name="input_kong_enabled"></a> [kong\_enabled](#input\_kong\_enabled) | Enable Kong services. | `bool` | `false` | no |
| <a name="input_project"></a> [project](#input\_project) | GCP project. | `string` | n/a | yes |
| <a name="input_resource_nodes_count"></a> [resource\_nodes\_count](#input\_resource\_nodes\_count) | Number of nodes for each of the gateway resources. | `number` | `1` | no |
| <a name="input_resources_machine_type"></a> [resources\_machine\_type](#input\_resources\_machine\_type) | Machine type for resources, overrides cluster\_machine\_type. | `string` | `""` | no |
| <a name="input_service_machine_type"></a> [service\_machine\_type](#input\_service\_machine\_type) | Machine type for services, overrides cluster\_machine\_type. | `string` | `""` | no |
| <a name="input_services_nodes_count"></a> [services\_nodes\_count](#input\_services\_nodes\_count) | Number of nodes for each of the gateway services. | `number` | `1` | no |
| <a name="input_tests_machine_type"></a> [tests\_machine\_type](#input\_tests\_machine\_type) | Machine type for tests, overrides cluster\_machine\_type. | `string` | `""` | no |
| <a name="input_tests_nodes_count"></a> [tests\_nodes\_count](#input\_tests\_nodes\_count) | Number of nodes for each of the tests services. | `number` | `1` | no |
| <a name="input_tyk_enabled"></a> [tyk\_enabled](#input\_tyk\_enabled) | Enable Tyk services. | `bool` | `true` | no |
| <a name="input_upstream_machine_type"></a> [upstream\_machine\_type](#input\_upstream\_machine\_type) | Machine type for upstreams, overrides cluster\_machine\_type. | `string` | `""` | no |
| <a name="input_upstream_nodes_count"></a> [upstream\_nodes\_count](#input\_upstream\_nodes\_count) | Number of nodes for each of the upstream services. | `number` | `1` | no |
