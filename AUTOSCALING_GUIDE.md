# Kubernetes Cluster Autoscaling Guide

## Overview
This guide explains how to test the native Kubernetes Cluster Autoscaler implementation for automatic node scaling during performance tests.

## Implementation Summary
- **GKE**: Uses built-in cluster autoscaler (enabled via Terraform autoscaling block)
- **EKS**: Deploys cluster-autoscaler addon with proper IAM roles and tags
- **AKS**: Uses built-in autoscaler (enabled via enable_auto_scaling flag)

## Configuration
### Node Pool Autoscaling Limits
- Service node pools (tyk, kong, gravitee, traefik): 2-6 nodes
- Infrastructure node pools: 1-3 nodes

## Testing on GKE

### 1. Deploy Infrastructure
```bash
# Navigate to GKE directory
cd gke

# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply configuration
terraform apply -auto-approve
```

### 2. Deploy Applications and Dependencies
```bash
# Navigate to deployments directory
cd ../deployments

# Set cluster context for GKE
gcloud container clusters get-credentials pt-<location> --zone=<location>

# Initialize and apply deployments
terraform init
terraform apply -auto-approve \
  -var="cluster_type=gke" \
  -var="cluster_name=pt-<location>"
```

### 3. Run Autoscaling Test
```bash
# Navigate to tests directory
cd ../tests

# Run test with scaling enabled
terraform init
terraform apply -auto-approve \
  -var="scaling_enabled=true" \
  -var="cluster_type=gke"
```

### 4. Monitor Autoscaling
Monitor the autoscaling behavior during the test:

```bash
# Watch node count changes
watch -n 5 'kubectl get nodes | grep -E "tyk|kong|gravitee|traefik" | wc -l'

# Check node pool status in GKE
gcloud container node-pools list --cluster=pt-<location> --zone=<location>

# Monitor pod scheduling and resource pressure
kubectl top nodes
kubectl get pods --all-namespaces -o wide | grep Pending

# Check autoscaler events (GKE logs this automatically)
kubectl get events -n kube-system | grep cluster-autoscaler
```

### 5. Test Phases
The K6 test runs three phases when `scaling_enabled=true`:

1. **Baseline Phase (0-10min)**: Normal load, nodes at minimum
2. **Scale-Up Phase (10-20min)**: 3x traffic, triggers node addition
3. **Scale-Down Phase (20-30min)**: Back to baseline, triggers node removal

### Expected Behavior
- During scale-up phase: New nodes should be added within 2-5 minutes when pods can't be scheduled
- During scale-down phase: Unused nodes should be removed after 10 minutes of low utilization
- GKE's autoscaler automatically handles all scaling decisions based on pod scheduling pressure

## Troubleshooting

### Check Autoscaler Status (GKE)
```bash
# GKE autoscaler is built-in, check node pool configuration
gcloud container node-pools describe <pool-name> \
  --cluster=pt-<location> \
  --zone=<location> \
  --format="get(autoscaling)"
```

### View Scaling Events
```bash
# Check Kubernetes events
kubectl get events --all-namespaces --sort-by='.lastTimestamp' | grep -i scale
```

### Verify Test Configuration
```bash
# Check if scaling is enabled in test
kubectl get configmap test-tyk-configmap -n tyk -o yaml | grep SCALING_ENABLED
```

## Cleanup
```bash
# Destroy test resources
cd tests && terraform destroy -auto-approve

# Destroy deployments
cd ../deployments && terraform destroy -auto-approve

# Destroy GKE cluster
cd ../gke && terraform destroy -auto-approve
```