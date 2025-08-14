#!/usr/bin/env bash
set -euo pipefail

NS="${NAMESPACE:-tyk}"
LABEL_KEY="${LABEL_KEY:-cloud.google.com/gke-nodepool}"

echo "=== Context ==="
kubectl cluster-info
echo

echo "=== Nodes (nodepool, instance type, zone) ==="
kubectl get nodes -L "${LABEL_KEY}",node.kubernetes.io/instance-type,topology.kubernetes.io/zone -o wide
echo

echo "=== Nodes -> nodepool label values ==="
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.metadata.labels.cloud\.google\.com/gke-nodepool}{"\n"}{end}' || true
echo

echo "=== Nodes -> taints (if any) ==="
kubectl get nodes -o json | jq -r '.items[] | [.metadata.name, ( .spec.taints // [] | map("\(.key)=\(.value):\(.effect)") | join(","))] | @tsv'
echo

echo "=== Pending pods (namespace: ${NS}) ==="
kubectl get pods -n "${NS}" --field-selector=status.phase=Pending -o wide || true
echo

echo "=== Describe gateway & dashboard pods (scheduling events) ==="
for app in tyk-gateway tyk-dashboard; do
  pods=$(kubectl get pods -n "${NS}" -l "app.kubernetes.io/name=${app},app.kubernetes.io/instance=tyk" -o name || true)
  if [[ -z "${pods}" ]]; then
    echo "No pods found with labels for ${app}."
    continue
  fi
  for p in ${pods}; do
    echo "--- ${p} ---"
    kubectl describe "${p}" -n "${NS}" | sed -n '/Events:/,$p'
  done
done
echo

echo "=== Recent scheduling-related warnings (namespace: ${NS}) ==="
kubectl get events -n "${NS}" --sort-by=.metadata.creationTimestamp | grep -E 'FailedScheduling|NotTriggerScaleUp|Preempt|Insufficient|didn.t match node selector|taint' || true
echo

echo "=== Resource requests vs node allocatable (summary) ==="
echo "-> Gateway requests:"
kubectl get deploy tyk-tyk-gateway -n "${NS}" -o json | jq '.spec.template.spec.containers[] | {name, requests: .resources.requests, limits: .resources.limits}' || true
echo
echo "-> Dashboard requests:"
kubectl get deploy tyk-tyk-dashboard -n "${NS}" -o json | jq '.spec.template.spec.containers[] | {name, requests: .resources.requests, limits: .resources.limits}' || true
echo
echo "-> Node allocatable:"
kubectl get nodes -o json | jq '.items[] | {name: .metadata.name, allocatable: .status.allocatable}' || true
echo

echo "=== PVCs (if any) in ${NS} ==="
kubectl get pvc -n "${NS}" || true
echo

echo "Done."