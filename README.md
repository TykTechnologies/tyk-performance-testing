# Tyk Performance Testing

This project is still a WIP. Schema might change and suggestions are welcome. 

## How to use

### Locally
The Repo can be cloned locally. You can stand up aks, eks, or gke using the respective folders or bring in your own cluster. 

#### Clusters
##### Terraform managed clusters
Once the clusters are created, you will need to add the connection config to your .kube/config. Here are examples per k8s services

###### AKS
```
az aks get-credentials \
   --resource-group "pt-westus" \
   --name "pt-westus"
```

###### EKS
```
aws eks --region "us-west-1" update-kubeconfig --name "pt-us-west-1"
```

###### GKE
```
gcloud container clusters get-credentials pt-us-west1-a \
   --zone us-west1-a \
   --project ce-team-zaid
```

##### Self-managed cluster requirements
To run the tests on your own cluster, you will need node labels that can house the different deployments and resources.

Example:
```
kubectl label nodes minikube node=dependencies
kubectl label nodes minikube-m02 node=tyk
kubectl label nodes minikube-m02 node=tyk-upstream
kubectl label nodes minikube-m03 node=tyk-tests
kubectl label nodes minikube-m04 node=tyk-resources
kubectl label nodes minikube-m05 node=kong
kubectl label nodes minikube-m06 node=kong-upstream
kubectl label nodes minikube-m07 node=kong-tests
kubectl label nodes minikube-m08 node=kong-resources
kubectl label nodes minikube-m09 node=gravitee
kubectl label nodes minikube-m10 node=gravitee-upstream
kubectl label nodes minikube-m11 node=gravitee-tests
kubectl label nodes minikube-m12 node=gravitee-resources
```

Note: dependencies are required, while the rest are required based on where the tests are being run. 

#### Deployments
Once you connect to a k8s cluster. You can run the deployment modules to set up the testing environments. Here is an example for the options available:
```
kubernetes_config_context = "performance-testing"

analytics_enabled             = false
auth_enabled                  = false
quota_enabled                 = false
quota_rate                    = 999999
quota_per                     = 3600
rate_limit_enabled            = false
rate_limit_rate               = 999999
rate_limit_per                = 1
open_telemetry_enabled        = false
open_telemetry_sampling_ratio = "0.5"

tyk_enabled                   = true
tyk_version                   = "v5.3.1"
tyk_license                   = ""
tyk_deployment_type           = "Deployment"
tyk_replica_count             = 1
tyk_external_traffic_policy   = "local"
tyk_go_gc                     = 1600
tyk_go_max_procs              = 8
tyk_resources_requests_cpu    = "0"
tyk_resources_requests_memory = "0"
tyk_resources_limits_cpu      = "0"
tyk_resources_limits_memory   = "0"

kong_enabled                   = false
kong_version                   = "v5"
kong_deployment_type           = "Deployment"
kong_replica_count             = 1
kong_external_traffic_policy   = "local"
kong_resources_requests_cpu    = "0"
kong_resources_requests_memory = "0"
kong_resources_limits_cpu      = "0"
kong_resources_limits_memory   = "0"

gravitee_enabled                   = false
gravitee_version                   = "4.3.5"
gravitee_deployment_type           = "Deployment"
gravitee_replica_count             = 1
gravitee_external_traffic_policy   = "local"
gravitee_resources_requests_cpu    = "0"
gravitee_resources_requests_memory = "0"
gravitee_resources_limits_cpu      = "0"
gravitee_resources_limits_memory   = "0"

grafana_service_type = "ClusterIP"
```

#### Tests
Once the environment is set up you can run the test's module. Here is an example of the options available:
```
kubernetes_config_context = "performance-testing"

tyk_enabled      = true
kong_enabled     = false
gravitee_enabled = false

tests_timestamp_enabled = true
tests_httpbin_enabled   = false

tests_config_executor      = "constant-arrival-rate"
tests_config_duration      = 15
tests_config_rate          = 20000
tests_config_virtual_users = 50
tests_config_parallelism   = 4
```
