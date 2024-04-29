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
   --resource-group "pt-Standard_F4s_v2" \
   --name "pt-Standard_F4s_v2"
```

###### EKS
```
aws eks --region "us-west-1" update-kubeconfig --name "pt-c5.xlarge"
```

###### GKE
```
gcloud container clusters get-credentials "pt-c2-standard-4" \
   --region "us-west1-a" \
   --project "performance-testing"
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
rate_limit_enabled            = false
open_telemetry_enabled        = false
open_telemetry_sampling_ratio = "0.5"

tyk_enabled                   = true
tyk_version                   = "v5.3.1"
tyk_deployment_type           = "Deployment"
tyk_replica_count             = 1
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
kong_resources_requests_cpu    = "0"
kong_resources_requests_memory = "0"
kong_resources_limits_cpu      = "0"
kong_resources_limits_memory   = "0"

gravitee_enabled                   = false
gravitee_version                   = "4.1"
gravitee_deployment_type           = "Deployment"
gravitee_replica_count             = 1
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

tests_parallelism       = 4
tests_timestamp_enabled = true
tests_httpbin_enabled   = false
tests_duration          = 15
```

### GitHub Actions
If you have access, you will be able to run the above setup through GitHub actions. The states of all the Terraform objects are stored in Terraform Cloud. 

##### Performance Test
Run the entire stack.

##### Cluster
Create cluster.

##### Deployments
Run deployments terraform module on an existing AKS cluster.

##### Tests
Run tests terraform module on an existing AKS cluster.

##### Destroy
Destroy setup and clear Terraform state.

### State
Tyk supports most of the config, aside from horizontal scaling.
Gravitee supports most of the config but is not tested.
Kong is not yet supported. 
