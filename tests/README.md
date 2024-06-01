## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 2.0.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tests"></a> [tests](#module\_tests) | ../modules/tests | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gravitee_enabled"></a> [gravitee\_enabled](#input\_gravitee\_enabled) | Enable Gravitee services. | `bool` | `false` | no |
| <a name="input_kong_enabled"></a> [kong\_enabled](#input\_kong\_enabled) | Enable Kong services. | `bool` | `false` | no |
| <a name="input_kubernetes_config_context"></a> [kubernetes\_config\_context](#input\_kubernetes\_config\_context) | Kubernetes config context. | `string` | `"minikube"` | no |
| <a name="input_kubernetes_config_path"></a> [kubernetes\_config\_path](#input\_kubernetes\_config\_path) | Kubernetes config file path. | `string` | `"~/.kube/config"` | no |
| <a name="input_tests_config_auth_enabled"></a> [tests\_config\_auth\_enabled](#input\_tests\_config\_auth\_enabled) | Enable Token Authentication. | `bool` | `false` | no |
| <a name="input_tests_config_auth_key_count"></a> [tests\_config\_auth\_key\_count](#input\_tests\_config\_auth\_key\_count) | Number of Authentication Tokens used for the test per test worker (tests\_config\_parallelism). | `number` | `100` | no |
| <a name="input_tests_config_duration"></a> [tests\_config\_duration](#input\_tests\_config\_duration) | Test duration in minutes. | `number` | `15` | no |
| <a name="input_tests_config_executor"></a> [tests\_config\_executor](#input\_tests\_config\_executor) | Choose the executor for the test. Options are: 'constant-vus', 'ramping-vus', 'constant-arrival-rate', 'ramping-arrival-rate'. | `string` | `"constant-arrival-rate"` | no |
| <a name="input_tests_config_parallelism"></a> [tests\_config\_parallelism](#input\_tests\_config\_parallelism) | Number of workers for the tests. | `number` | `4` | no |
| <a name="input_tests_config_ramping_steps"></a> [tests\_config\_ramping\_steps](#input\_tests\_config\_ramping\_steps) | Number of ramping steps for the test, applies for 'ramping-vus' and 'ramping-arrival-rate' executors. | `number` | `10` | no |
| <a name="input_tests_config_rate"></a> [tests\_config\_rate](#input\_tests\_config\_rate) | Test RPS, applies for 'constant-arrival-rate' and 'ramping-arrival-rate' executors. | `number` | `20000` | no |
| <a name="input_tests_config_virtual_users"></a> [tests\_config\_virtual\_users](#input\_tests\_config\_virtual\_users) | Number of virtual users to be used for the test. | `number` | `50` | no |
| <a name="input_tests_httpbin_enabled"></a> [tests\_httpbin\_enabled](#input\_tests\_httpbin\_enabled) | Turn on httpbin test. This will return a 200 OK. | `bool` | `false` | no |
| <a name="input_tests_timestamp_enabled"></a> [tests\_timestamp\_enabled](#input\_tests\_timestamp\_enabled) | Turn on timestamp test. This will return a timestamp json object. | `bool` | `true` | no |
| <a name="input_tyk_enabled"></a> [tyk\_enabled](#input\_tyk\_enabled) | Enable Tyk services. | `bool` | `true` | no |
