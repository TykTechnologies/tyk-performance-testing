#!/bin/bash
# Script to analyze why requests have high latency instead of failing fast during node failure

echo "=== Analyzing High Latency During Node Failure ==="

# 1. Check Service configuration for session affinity
echo -e "\n1. Service Configuration (Session Affinity & Traffic Policy):"
kubectl get svc -n tyk gateway-tyk-svc-tyk-gateway -o yaml | grep -E "sessionAffinity|externalTrafficPolicy|internalTrafficPolicy|timeoutSeconds|publishNotReadyAddresses"

# 2. Check if endpoints get updated when pods are deleted
echo -e "\n2. Current Endpoints Status:"
kubectl get endpoints -n tyk gateway-tyk-svc-tyk-gateway -o json | jq '.subsets[0] | {addresses: .addresses | length, notReadyAddresses: .notReadyAddresses | length}'

# 3. Check kube-proxy mode
echo -e "\n3. Kube-proxy Configuration:"
kubectl get configmap -n kube-system kube-proxy -o yaml | grep -E "mode:|tcpTimeout|tcpFinTimeout|conntrackTCPTimeoutEstablished"

# 4. Check if using iptables or ipvs
echo -e "\n4. Kube-proxy Mode Detection:"
kubectl logs -n kube-system $(kubectl get pods -n kube-system | grep kube-proxy | head -1 | awk '{print $1}') --tail=50 | grep -E "Using|mode"

# 5. Check Tyk Gateway configuration for timeouts
echo -e "\n5. Tyk Gateway Timeout Configuration:"
kubectl get configmap -n tyk gateway-tyk-tyk-gateway -o yaml | grep -i timeout || echo "No timeout configs in ConfigMap"

# 6. Check ingress/load balancer health check settings
echo -e "\n6. Ingress/LoadBalancer Configuration:"
kubectl get ingress -n tyk -o yaml 2>/dev/null | grep -E "timeout|health" || echo "No ingress found"
kubectl get svc -n tyk gateway-tyk-svc-tyk-gateway -o yaml | grep -E "healthCheckNodePort|loadBalancerSourceRanges"

# 7. Check pod readiness gates
echo -e "\n7. Pod Readiness Gates:"
kubectl get pods -n tyk -l app=gateway-tyk-tyk-gateway -o json | jq '.items[0].spec.readinessGates'

# 8. Check for PodDisruptionBudget
echo -e "\n8. PodDisruptionBudget:"
kubectl get pdb -n tyk -o yaml 2>/dev/null || echo "No PDB found"

# 9. Analyze conntrack table size (if accessible)
echo -e "\n9. Connection Tracking (if accessible):"
# This would need to run on a node
echo "Would need node access to check: sysctl net.netfilter.nf_conntrack_tcp_timeout_established"

echo -e "\n=== Analysis Summary ==="
echo "Common causes of high latency instead of fast failures:"
echo "1. TCP retransmission timeouts (default ~15 seconds for established connections)"
echo "2. Service endpoints not immediately updated when pods are force-deleted"
echo "3. kube-proxy using iptables mode with connection tracking"
echo "4. Load balancer health checks taking time to detect failure"
echo "5. No TCP RST packets sent when pods are force-deleted"
echo ""
echo "Potential solutions:"
echo "1. Configure service with 'publishNotReadyAddresses: false' (default)"
echo "2. Use 'externalTrafficPolicy: Local' to avoid cross-node traffic"
echo "3. Configure aggressive timeouts in Tyk Gateway"
echo "4. Use PodDisruptionBudget to ensure minimum availability"
echo "5. Configure TCP keep-alive with shorter intervals"