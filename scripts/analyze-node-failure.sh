#!/bin/bash
# Script to analyze why node failure causes 8-second latency spikes

echo "=== Analyzing Node Failure Impact ==="

# Check service configuration
echo "1. Service Configuration:"
kubectl get svc -n tyk gateway-tyk-svc-tyk-gateway -o yaml | grep -E "sessionAffinity|publishNotReadyAddresses|externalTrafficPolicy"

# Check if there's a PodDisruptionBudget
echo -e "\n2. PodDisruptionBudget:"
kubectl get pdb -n tyk 2>/dev/null || echo "No PDB found"

# Check readiness probe configuration
echo -e "\n3. Readiness Probe Settings:"
kubectl get deploy -n tyk gateway-tyk-tyk-gateway -o yaml | grep -A10 "readinessProbe:"

# Check termination grace period
echo -e "\n4. Termination Grace Period:"
kubectl get deploy -n tyk gateway-tyk-tyk-gateway -o yaml | grep "terminationGracePeriodSeconds"

# Check current endpoints
echo -e "\n5. Current Service Endpoints:"
kubectl get endpoints -n tyk gateway-tyk-svc-tyk-gateway -o yaml

# Check ingress/load balancer status
echo -e "\n6. Ingress Status:"
kubectl get ingress -n tyk -o wide 2>/dev/null || echo "No ingress found"

# Check for any NetworkPolicies that might affect traffic
echo -e "\n7. Network Policies:"
kubectl get networkpolicy -n tyk 2>/dev/null || echo "No network policies found"

# Check connection draining settings
echo -e "\n8. Connection/Session Settings:"
kubectl get svc -n tyk gateway-tyk-svc-tyk-gateway -o yaml | grep -E "timeoutSeconds|drainingTimeout"

echo -e "\n=== Analysis Complete ==="
echo "Possible causes of 8-second latency:"
echo "1. TCP connection timeouts to deleted pod IPs"
echo "2. Service endpoints not updating quickly"
echo "3. Load balancer health checks taking time to fail"
echo "4. No connection draining before pod termination"