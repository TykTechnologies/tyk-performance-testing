#!/bin/bash
# Script to configure Tyk gateway service for fast failure during node outages

echo "=== Configuring Service for Fast Failure ==="

NAMESPACE="tyk"
SERVICE_NAME="gateway-tyk-svc-tyk-gateway"

# 1. Patch service to use Local traffic policy (avoids cross-node traffic to dead pods)
echo "1. Setting externalTrafficPolicy to Local..."
kubectl patch svc $SERVICE_NAME -n $NAMESPACE -p '{"spec":{"externalTrafficPolicy":"Local"}}' 2>/dev/null || echo "  Service might not be LoadBalancer type"

# 2. Ensure session affinity is None (no sticky sessions that would route to dead pods)
echo "2. Ensuring session affinity is None..."
kubectl patch svc $SERVICE_NAME -n $NAMESPACE -p '{"spec":{"sessionAffinity":"None"}}'

# 3. Add annotation for faster AWS ELB health checks (if on AWS)
echo "3. Configuring faster health checks for cloud load balancers..."
kubectl annotate svc $SERVICE_NAME -n $NAMESPACE \
  "service.beta.kubernetes.io/aws-load-balancer-healthcheck-interval=5" \
  "service.beta.kubernetes.io/aws-load-balancer-healthcheck-timeout=2" \
  "service.beta.kubernetes.io/aws-load-balancer-healthcheck-unhealthy-threshold=2" \
  "service.beta.kubernetes.io/aws-load-balancer-healthcheck-healthy-threshold=2" \
  --overwrite 2>/dev/null || echo "  Not on AWS or annotations already set"

# 4. Configure Tyk Gateway timeouts via ConfigMap
echo "4. Checking Tyk Gateway timeout configuration..."
cat <<EOF > /tmp/tyk-timeout-patch.yaml
data:
  tyk.conf: |
    {
      "http_server_options": {
        "read_timeout": 10,
        "write_timeout": 10,
        "idle_timeout": 10
      },
      "proxy_default_timeout": 10,
      "max_idle_connections": 100,
      "max_idle_connections_per_host": 10,
      "proxy_close_connections": true
    }
EOF

echo "  Note: Tyk timeout configuration should be set in the Helm values"

# 5. Create a NetworkPolicy to block traffic to NotReady pods (optional, aggressive)
echo "5. Creating NetworkPolicy for aggressive failure handling..."
cat <<EOF | kubectl apply -f - 2>/dev/null || echo "  NetworkPolicy creation failed (might not be supported)"
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: block-notready-pods
  namespace: $NAMESPACE
spec:
  podSelector:
    matchLabels:
      app: gateway-tyk-tyk-gateway
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector: {}
    - namespaceSelector: {}
EOF

# 6. Check current endpoint status
echo -e "\n6. Current Endpoint Status:"
kubectl get endpoints $SERVICE_NAME -n $NAMESPACE -o json | jq '{
  ready: .subsets[0].addresses | length,
  notReady: .subsets[0].notReadyAddresses | length,
  total: (.subsets[0].addresses | length) + (.subsets[0].notReadyAddresses | length // 0)
}'

# 7. Show current service configuration
echo -e "\n7. Current Service Configuration:"
kubectl get svc $SERVICE_NAME -n $NAMESPACE -o json | jq '.spec | {
  type: .type,
  sessionAffinity: .sessionAffinity,
  externalTrafficPolicy: .externalTrafficPolicy,
  internalTrafficPolicy: .internalTrafficPolicy,
  publishNotReadyAddresses: .publishNotReadyAddresses,
  clusterIP: .clusterIP
}'

echo -e "\n=== Recommendations ==="
echo "To reduce latency during node failures:"
echo "1. Set aggressive timeouts in Tyk Gateway configuration (via Helm values)"
echo "2. Use 'externalTrafficPolicy: Local' if using LoadBalancer service"
echo "3. Configure cloud provider health checks for faster detection"
echo "4. Consider using a service mesh with circuit breakers"
echo "5. Implement retry logic with exponential backoff in clients"
echo ""
echo "Note: TCP connection timeouts are at kernel level and harder to control"
echo "Consider using HTTP keep-alive with shorter timeouts"