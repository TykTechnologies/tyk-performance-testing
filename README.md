# Tyk Performance Testing
[![aks](https://github.com/TykTechnologies/tyk-performance-testing/actions/workflows/AKS.yml/badge.svg)](https://github.com/TykTechnologies/tyk-performance-testing/actions/workflows/AKS.yml)
[![EKS](https://github.com/TykTechnologies/tyk-performance-testing/actions/workflows/EKS.yml/badge.svg)](https://github.com/TykTechnologies/tyk-performance-testing/actions/workflows/EKS.yml)
[![GKE](https://github.com/TykTechnologies/tyk-performance-testing/actions/workflows/GKE.yml/badge.svg)](https://github.com/TykTechnologies/tyk-performance-testing/actions/workflows/GKE.yml)

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

### Feature matrix

| Gateway  | Database Analytics | Prometheus Analytics | AuthToken          | JWT                | Quota                             | Rate Limiting      | Open Telemetry     | 
|----------|--------------------|----------------------|--------------------|--------------------|-----------------------------------|--------------------|--------------------|
| Tyk      | :white_check_mark: | :white_check_mark:   | :white_check_mark: | :white_check_mark: | :white_check_mark:                | :white_check_mark: | :white_check_mark: |
| Kong     | :x:                | :white_check_mark:   | :white_check_mark: | :x:                | Implemented through Rate Limiting | :white_check_mark: | :white_check_mark: | 
| Gravitee | :white_check_mark: | :white_check_mark:   | :white_check_mark: | :x:                | Implemented through Rate Limiting | :white_check_mark: | :x:                |

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

analytics_database_enabled    = false
analytics_prometheus_enabled  = false
auth_enabled                  = false
auth_type                     = "authToken"
quota_enabled                 = false
quota_rate                    = 999999
quota_per                     = 3600
rate_limit_enabled            = false
rate_limit_rate               = 999999
rate_limit_per                = 60
open_telemetry_enabled        = false
open_telemetry_sampling_ratio = "0.5"

hpa_enabled                 = false
hpa_max_replica_count       = 10
replica_count               = 1
hpa_avg_cpu_util_percentage = 80
external_traffic_policy     = "Local"
resources_requests_cpu      = "0"
resources_requests_memory   = "0"
resources_limits_cpu        = "0"
resources_limits_memory     = "0"

tyk_enabled          = true
tyk_version          = "v5.6"
tyk_license          = ""
tyk_deployment_type  = "Deployment"
tyk_service_type     = "ClusterIP"
tyk_go_gc            = 1600
tyk_go_max_procs     = 8
tyk_profiler_enabled = false

kong_enabled         = false
kong_version         = "3.8"
kong_deployment_type = "Deployment"
kong_service_type    = "ClusterIP"

gravitee_enabled         = false
gravitee_version         = "4.5"
gravitee_deployment_type = "Deployment"
gravitee_service_type    = "ClusterIP"

grafana_service_type = "ClusterIP"
```

#### Tests
Once the environment is set up you can run the test's module. Here is an example of the options available:
```
kubernetes_config_context = "performance-testing"

tyk_enabled      = true
kong_enabled     = false
gravitee_enabled = false

tests_fortio_options = "size=20"
tests_executor       = "constant-arrival-rate"
tests_duration       = 15
tests_rate           = 20000
tests_virtual_users  = 50
tests_parallelism    = 1
```
