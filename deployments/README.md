## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 2.0.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_deployments"></a> [deployments](#module\_deployments) | ../modules/deployments | n/a |

## Inputs

| Name| Description| Type| Default| Required |
|---------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------|:--------:|
| <a name="input_analytics_database_enabled"></a> [analytics\_database\_enabled](#input\_analytics\_database\_enabled)| Enables metrics collection on gateway services and stores them in gateways default database. | `bool`| `false`| no |
| <a name="input_analytics_prometheus_enabled"></a> [analytics\_prometheus\_enabled](#input\_analytics\_prometheus\_enabled)| Enables metrics collection on gateway services and aggregates them on an endpoint for prometheus to scrape.| `bool`| `false`| no |
| <a name="input_auth_enabled"></a> [auth\_enabled](#input\_auth\_enabled)| Enables authorization on gateway APIs. | `bool`| `false`| no |
| <a name="input_auth_type"></a> [auth\_type](#input\_auth\_type) | Authorization type on gateway APIs. authToken, JWT-RSA, or JWT-HMAC. | `string`| `authToken`| no |
| <a name="input_external_traffic_policy"></a> [external\_traffic\_policy](#input\_external\_traffic\_policy) | Gateway service external traffic policy. Set to 'local' when using 1 k8s node per gateway and 'cluster' when using multiple k8s nodes per gateway for optimal routing performance. | `string`| `"Local"`| no |
| <a name="input_grafana_service_type"></a> [grafana\_service\_type](#input\_grafana\_service\_type)| Grafana Dashboard service type. Set to 'LoadBalancer' type to be able to access Dashboard over the internet. | `string`| `ClusterIP`| yes |
| <a name="input_gravitee_deployment_type"></a> [gravitee\_deployment\_type](#input\_gravitee\_deployment\_type)| Gravitee Gateway deployment type.| `string`| `"Deployment"` | no |
| <a name="input_gravitee_service_type"></a> [gravitee\_service\_type](#input\_gravitee\_service\_type) | Gravitee Gateway service type. | `string`| `"ClusterIP"`| no |
| <a name="input_gravitee_enabled"></a> [gravitee\_enabled](#input\_gravitee\_enabled)| Enable Gravitee services.| `bool`| `false`| no |
| <a name="input_gravitee_nginx_enabled"></a> [gravitee\_nginx\_enabled](#input\_gravitee\_nginx\_enabled)| Gravitee Nginx controller for exposing UI and Portal.| `bool`| `false`| no |
| <a name="input_gravitee_version"></a> [gravitee\_version](#input\_gravitee\_version)| Gravitee Gateway version.| `string`| `"4.5"`| no |
| <a name="input_header_injection_req_enabled"></a> [header\_injection\_req\_enabled](#input\_header\_injection\_req\_enabled)| Gateway will inject an X-API-REQ header with Foo value.| `bool`| `false`| no |
| <a name="input_header_injection_res_enabled"></a> [header\_injection\_res\_enabled](#input\_header\_injection\_res\_enabled)| Gateway will inject an X-API-RES header with Bar value.| `bool`| `false`| no |
| <a name="input_hpa_avg_cpu_util_percentage"></a> [hpa\_avg\_cpu\_util\_percentage](#input\_hpa\_avg\_cpu\_util\_percentage) | Gateways Horizontal Pod Autoscaler average CPU utilization percentage for scaling. | `number`| `80` | no |
| <a name="input_hpa_enabled"></a> [hpa\_enabled](#input\_hpa\_enabled) | Option to enable gateways Horizontal Pod Autoscaler. | `bool`| `true` | no |
| <a name="input_hpa_max_replica_count"></a> [hpa\_max\_replica\_count](#input\_hpa\_max\_replica\_count) | Gateways Horizontal Pod Autoscaler max replica count.| `number`| `4`| no |
| <a name="input_kong_deployment_type"></a> [kong\_deployment\_type](#input\_kong\_deployment\_type)| Kong Gateway deployment type.| `string`| `"Deployment"` | no |
| <a name="input_kong_service_type"></a> [kong\_service\_type](#input\_kong\_service\_type) | Kong Gateway service type. | `string`| `"ClusterIP"`| no |
| <a name="input_kong_enabled"></a> [kong\_enabled](#input\_kong\_enabled)| Enable Kong services.| `bool`| `false`| no |
| <a name="input_kong_version"></a> [kong\_version](#input\_kong\_version)| Kong Gateway version.| `string`| `"3.8"`| no |
| <a name="input_kubernetes_config_context"></a> [kubernetes\_config\_context](#input\_kubernetes\_config\_context) | Kubernetes config context. | `string`| `"minikube"` | no |
| <a name="input_kubernetes_config_path"></a> [kubernetes\_config\_path](#input\_kubernetes\_config\_path)| Kubernetes config file path. | `string`| `"~/.kube/config"` | no |
| <a name="input_node_labels"></a> [node\_labels](#input\_node\_labels) | Mapping for node labels to determine the values for node selectors for each deployment.| <pre>object({<br> dependencies = string<br> tyk = string<br> tyk-upstream = string<br> tyk-tests = string<br> tyk-resources = string<br> kong = string<br> kong-upstream = string<br> kong-tests = string<br> kong-resources = string<br> gravitee = string<br> gravitee-upstream = string<br> gravitee-tests = string<br> gravitee-resources = string<br> })</pre> | `null` | no |
| <a name="input_open_telemetry_enabled"></a> [open\_telemetry\_enabled](#input\_open\_telemetry\_enabled)| Enable Open Telemetry and trace collection on gateway services.| `bool`| `false`| no |
| <a name="input_open_telemetry_sampling_ratio"></a> [open\_telemetry\_sampling\_ratio](#input\_open\_telemetry\_sampling\_ratio) | Open Telemetry sampling ration 0 to 1.0 range. | `string`| `"0.5"`| no |
| <a name="input_quota_enabled"></a> [quota\_enabled](#input\_quota\_enabled) | Enables quota management on gateway APIs.| `bool`| `false`| no |
| <a name="input_quota_per"></a> [quota\_per](#input\_quota\_per) | Quota management reset interval in seconds.| `number`| `3600` | no |
| <a name="input_quota_rate"></a> [quota\_rate](#input\_quota\_rate)| Quota management rate on gateway APIs. | `number`| `999999` | no |
| <a name="input_rate_limit_enabled"></a> [rate\_limit\_enabled](#input\_rate\_limit\_enabled)| Enables rate limiting on gateway APIs. | `bool`| `false`| no |
| <a name="input_rate_limit_per"></a> [rate\_limit\_per](#input\_rate\_limit\_per)| Rate Limit reset interval in seconds.| `number`| `60` | no |
| <a name="input_rate_limit_rate"></a> [rate\_limit\_rate](#input\_rate\_limit\_rate) | Rate Limit rate on gateway APIs. | `number`| `999999` | no |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | Gateway replica count. | `number`| `1`| no |
| <a name="input_resources_limits_cpu"></a> [resources\_limits\_cpu](#input\_resources\_limits\_cpu)| Gateway CPU requests.| `string`| `"0"`| no |
| <a name="input_resources_limits_memory"></a> [resources\_limits\_memory](#input\_resources\_limits\_memory) | Gateway memory requests. | `string`| `"0"`| no |
| <a name="input_resources_requests_cpu"></a> [resources\_requests\_cpu](#input\_resources\_requests\_cpu)| Gateway CPU requests.| `string`| `"0"`| no |
| <a name="input_resources_requests_memory"></a> [resources\_requests\_memory](#input\_resources\_requests\_memory) | Gateway memory requests. | `string`| `"0"`| no |
| <a name="input_traefik_deployment_type"></a> [traefik\_deployment\_type](#input\_traefik\_deployment\_type)| Traefik Gateway deployment type.| `string`| `"Deployment"` | no |
| <a name="input_traefik_service_type"></a> [traefik\_service\_type](#input\_traefik\_service\_type) | Traefik Gateway service type. | `string`| `"ClusterIP"`| no |
| <a name="input_traefik_enabled"></a> [traefik\_enabled](#input\_traefik\_enabled)| Enable Traefik services.| `bool`| `false`| no |
| <a name="input_traefik_version"></a> [traefik\_version](#input\_traefik\_version)| Traefik Gateway version.| `string`| `"3.3"`| no |
| <a name="input_tyk_deployment_type"></a> [tyk\_deployment\_type](#input\_tyk\_deployment\_type) | Tyk Gateway deployment type. | `string`| `"Deployment"` | no |
| <a name="input_tyk_service_type"></a> [tyk\_service\_type](#input\_tyk\_service\_type)| Tyk Gateway service type.| `string`| `"ClusterIP"`| no |
| <a name="input_tyk_enabled"></a> [tyk\_enabled](#input\_tyk\_enabled) | Enable Tyk services. | `bool`| `true` | no |
| <a name="input_tyk_go_gc"></a> [tyk\_go\_gc](#input\_tyk\_go\_gc) | Target percentage for garbage collection execution in Go.| `number`| `1600` | no |
| <a name="input_tyk_go_max_procs"></a> [tyk\_go\_max\_procs](#input\_tyk\_go\_max\_procs)| Limits the number of operating system threads that can execute user-level Go code simultaneously. Matching the value to threads * cpu limit allows for optimal performance.| `number`| `8`| no |
| <a name="input_tyk_profiler_enabled"></a> [tyk\_profiler\_enabled](#input\_tyk\_profiler\_enabled)| Enables profiling on the Tyk Gateway.| `bool`| `false`| no |
| <a name="input_tyk_license"></a> [tyk\_license](#input\_tyk\_license) | Tyk self-managed license.| `string`| n/a| yes |
| <a name="input_tyk_version"></a> [tyk\_version](#input\_tyk\_version) | Tyk Gateway version. | `string`| `"v5.7"` | no |
| <a name="input_upstream_enabled"></a> [upstream\_enabled](#input\_upstream\_enabled)| Enable Fortio upstream service for baseline testing. | `bool`| `false`| no |
