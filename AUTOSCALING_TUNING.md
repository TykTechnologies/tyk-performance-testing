# Autoscaling Tuning Guide

## Why Autoscaling Isn't Triggering

The cluster autoscaler adds nodes when pods cannot be scheduled due to insufficient resources. Currently, autoscaling may not trigger because:

1. **No Resource Requests**: Pods have `resources_requests_cpu="0"` and `resources_requests_memory="0"`
2. **Limited HPA Scaling**: HPA max replicas is set to only 4
3. **Sufficient Node Capacity**: Existing nodes can handle the 3x traffic increase

## Configuration for Proper Autoscaling

### 1. Set Resource Requests and Limits

In `deployments/main.tfvars` or when running terraform:

```bash
# Recommended values for autoscaling tests
resources_requests_cpu      = "500m"    # Request 0.5 CPU cores per pod
resources_requests_memory   = "512Mi"   # Request 512MB memory per pod
resources_limits_cpu        = "2000m"   # Limit to 2 CPU cores per pod
resources_limits_memory     = "2Gi"     # Limit to 2GB memory per pod
```

### 2. Increase HPA Max Replicas

```bash
hpa_max_replica_count = 10  # Allow HPA to scale up to 10 replicas
```

### 3. Run Tests with These Settings

```bash
cd deployments
terraform apply -auto-approve \
  -var="cluster_type=gke" \
  -var="cluster_name=pt-<location>" \
  -var="resources_requests_cpu=500m" \
  -var="resources_requests_memory=512Mi" \
  -var="resources_limits_cpu=2000m" \
  -var="resources_limits_memory=2Gi" \
  -var="hpa_max_replica_count=10"
```

## How Autoscaling Works

### Pod Autoscaling (HPA)
1. Traffic increases from 20k to 60k requests/second during scale-up phase
2. CPU utilization rises above 80% threshold
3. HPA creates more pod replicas (up to max_replica_count)
4. Each new pod requests 500m CPU and 512Mi memory

### Node Autoscaling (Cluster Autoscaler)
1. When HPA tries to create new pods, they request resources
2. If current nodes don't have enough capacity, pods enter "Pending" state
3. Cluster autoscaler detects pending pods and adds nodes
4. New nodes join the cluster (2-5 minutes on GKE)
5. Pending pods are scheduled on new nodes

### Scale-Down
1. Traffic decreases back to baseline
2. HPA removes excess pod replicas
3. After 10 minutes of low utilization, cluster autoscaler removes unused nodes

## Monitoring Autoscaling

### Watch Pod Scaling
```bash
watch -n 2 'kubectl get hpa -A'
watch -n 2 'kubectl get pods -n tyk | grep gateway'
```

### Watch Node Scaling
```bash
watch -n 5 'kubectl get nodes -o wide | grep tyk'
```

### Check for Pending Pods
```bash
kubectl get pods --all-namespaces | grep Pending
```

### View Autoscaler Events
```bash
kubectl get events -A | grep -E "TriggeredScaleUp|ScaleDown|FailedScheduling"
```

## Tuning Tips

### If Nodes Don't Scale Up:
- Increase resource requests per pod
- Decrease HPA CPU threshold (e.g., 60% instead of 80%)
- Increase traffic multiplier (e.g., 5x instead of 3x)
- Verify node pool max size is sufficient

### If Scaling is Too Aggressive:
- Increase HPA CPU threshold
- Add pod disruption budgets
- Increase scale-down delay in cluster autoscaler

### Example: Force Scaling for Testing
```bash
# Set high resource requests to force node scaling
terraform apply -auto-approve \
  -var="resources_requests_cpu=2000m" \
  -var="resources_requests_memory=4Gi" \
  -var="hpa_max_replica_count=20"
```

This configuration will require significant resources per pod, making it more likely to exceed node capacity and trigger scaling.