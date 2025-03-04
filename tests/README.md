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
| <a name="input_tests_auth_key_count"></a> [tests\_auth\_key\_count](#input\_tests\_auth\_key\_count) | Number of Authentication Tokens used for the test per test worker (tests\_parallelism). | `number` | `100` | no |
| <a name="input_tests_duration"></a> [tests\_duration](#input\_tests\_duration) | Test duration in minutes. | `number` | `15` | no |
| <a name="input_tests_executor"></a> [tests\_executor](#input\_tests\_executor) | Choose the executor for the test. Options are: 'constant-vus', 'ramping-vus', 'constant-arrival-rate', 'ramping-arrival-rate', 'externally-controlled'. | `string` | `"constant-arrival-rate"` | no |
| <a name="input_tests_fortio_options"></a> [tests\_fortio\_options](#input\_tests\_fortio\_options) | Set the parameters for the request to fortio-server. Read more at https://github.com/fortio/fortio?tab=readme-ov-file#server-urls-and-features | `string` | `"size=20"` | no |
| <a name="input_tests_parallelism"></a> [tests\_parallelism](#input\_tests\_parallelism) | Number of workers for the tests. | `number` | `1` | no |
| <a name="input_tests_ramping_steps"></a> [tests\_ramping\_steps](#input\_tests\_ramping\_steps) | Number of ramping steps for the test, applies for 'ramping-vus' and 'ramping-arrival-rate' executors. | `number` | `10` | no |
| <a name="input_tests_rate"></a> [tests\_rate](#input\_tests\_rate) | Test RPS, applies for 'constant-arrival-rate' and 'ramping-arrival-rate' executors. | `number` | `5000` | no |
| <a name="input_tests_virtual_users"></a> [tests\_virtual\_users](#input\_tests\_virtual\_users) | Number of virtual users to be used for the test. | `number` | `50` | no |
| <a name="input_tyk_enabled"></a> [tyk\_enabled](#input\_tyk\_enabled) | Enable Tyk services. | `bool` | `true` | no |
| <a name="input_upstream_enabled"></a> [upstream\_enabled](#input\_upstream\_enabled) | Enable Fortio upstream service for baseline testing. | `bool` | `false` | no |

### externally-controlled

```
kubernetes_config_context = "performance-testing"

tyk_enabled      = true
kong_enabled     = true
gravitee_enabled = true
upstream_enabled = false

tests_fortio_options = "size=20"
tests_executor       = "externally-controlled"
tests_auth_key_count = 10
tests_ramping_steps  = 10
tests_duration       = 15
tests_rate           = 5000
tests_virtual_users  = 1000
tests_parallelism    = 1
```

Increase VUs dynamically over the next 15 minutes.
```
for i in {1..100}; do
   VUS=$((i * 10))

   kubectl exec -it $(kubectl get pod -l k6_cr=test -l runner=true -n tyk      -o jsonpath='{.items[*].metadata.name}') -n tyk      -- k6 scale --vus $VUS
   kubectl exec -it $(kubectl get pod -l k6_cr=test -l runner=true -n kong     -o jsonpath='{.items[*].metadata.name}') -n kong     -- k6 scale --vus $VUS
   kubectl exec -it $(kubectl get pod -l k6_cr=test -l runner=true -n gravitee -o jsonpath='{.items[*].metadata.name}') -n gravitee -- k6 scale --vus $VUS

   sleep 9
done
```
