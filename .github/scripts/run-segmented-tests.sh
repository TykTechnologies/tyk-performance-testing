#!/bin/bash

# Segmented k6 Performance Test Runner
# Handles long-duration tests by splitting them into 60-minute segments
# to avoid k6 Prometheus timeout issues (GitHub issue #3498)

set -euo pipefail

# Input parameters
TEST_DURATION_MINUTES="$1"
SIMULATE_NODE_FAILURE="${2:-false}"
NODE_FAILURE_DELAY_MINUTES="${3:-60}"
NODE_DOWNTIME_MINUTES="${4:-5}"
GUARANTEE_ERRORS="${5:-false}"

echo "=== Segmented k6 Test Runner Started ==="
echo "Total test duration: ${TEST_DURATION_MINUTES} minutes"
echo "Node failure simulation: ${SIMULATE_NODE_FAILURE}"

# Start k6 pod monitoring in background to capture logs during execution
start_k6_monitoring() {
  (
    echo "Starting k6 pod monitoring in background..."
    sleep 30  # Give tests time to start
    
    LAST_INITIALIZER_LOG_LINE=0
    LAST_RUNNER_LOG_LINE=0
    
    while true; do
      # === Show Job-level activeDeadlineSeconds for k6 initializer/runner/starter Jobs ===
      echo ""
      echo "=== k6 Job activeDeadlineSeconds (snapshot) at $(date '+%H:%M:%S') ==="
      # Show k6 Jobs with their activeDeadlineSeconds
      echo "Initializer jobs:"
      kubectl get jobs -A -l "k6_cr" -o json 2>/dev/null | jq -r '.items[] | select(.metadata.labels["job-name"] // "" | contains("initializer")) | "\(.metadata.namespace)/\(.metadata.name): ADS=\(.spec.activeDeadlineSeconds // "none")"' || echo "  (none)"
      
      echo "Runner jobs:"
      kubectl get jobs -A -l "k6_cr,runner=true" -o json 2>/dev/null | jq -r '.items[] | "\(.metadata.namespace)/\(.metadata.name): ADS=\(.spec.activeDeadlineSeconds // "none")"' || echo "  (none)"
      
      echo "Starter jobs:"
      kubectl get jobs -A -l "k6_cr" -o json 2>/dev/null | jq -r '.items[] | select(.metadata.labels["job-name"] // "" | contains("starter")) | "\(.metadata.namespace)/\(.metadata.name): ADS=\(.spec.activeDeadlineSeconds // "none")"' || echo "  (none)"

      # Optional: warn loudly if any runner job is pinned to 3600s
      RUNNER_ADS=$(kubectl get jobs -A -l "k6_cr,runner=true" -o json 2>/dev/null \
        | jq -r '.items[] | (.spec.activeDeadlineSeconds // 0)' | sort -u)
      if echo "$RUNNER_ADS" | grep -q "^3600$"; then
        echo "⚠️  WARNING: Detected runner Job activeDeadlineSeconds=3600 (1h). This will kill the test after exactly 60 minutes!"
      fi

      # Check for k6 initializer pods (these run first and set up the test)
      K6_INITIALIZERS=$(kubectl get pods -A -l "k6_cr" -o json 2>/dev/null | jq -r '.items[] | select(.metadata.labels["job-name"] // "" | contains("initializer")) | "\(.metadata.namespace)/\(.metadata.name)"' || echo "")
      
      if [[ -n "$K6_INITIALIZERS" ]]; then
        echo ""
        echo "=== k6 Initializer Pod Logs at $(date '+%H:%M:%S') ==="
        for initializer in $K6_INITIALIZERS; do
          NS=$(echo $initializer | cut -d'/' -f1)
          POD=$(echo $initializer | cut -d'/' -f2)
          
          # Get initializer logs focusing on duration setup
          echo "Initializer $POD logs (duration setup):"
          kubectl logs -n "$NS" "$POD" 2>/dev/null | grep -E "autoscaling-gradual|totalMinutes|DURATION|stages|parse|resolve|environment" | tail -20 || echo "  No duration-related logs yet"
        done
      fi
      
      # Check for k6 runner pods
      K6_RUNNERS=$(kubectl get pods -A -l "k6_cr,runner=true" -o json 2>/dev/null | jq -r '.items[] | "\(.metadata.namespace)/\(.metadata.name)"' || echo "")
      
      if [[ -n "$K6_RUNNERS" ]]; then
        echo ""
        echo "=== k6 Runner Pod Status at $(date '+%H:%M:%S') ==="
        for runner in $K6_RUNNERS; do
          NS=$(echo $runner | cut -d'/' -f1)
          POD=$(echo $runner | cut -d'/' -f2)
          
          # Get pod status
          STATUS=$(kubectl get pod -n "$NS" "$POD" -o jsonpath='{.status.phase}' 2>/dev/null || echo "Unknown")
          READY=$(kubectl get pod -n "$NS" "$POD" -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || echo "Unknown")
          echo "Pod: $POD - Status: $STATUS, Ready: $READY"
          
          # Get recent execution logs
          echo "Recent execution logs from $POD:"
          kubectl logs -n "$NS" "$POD" --tail=30 2>/dev/null | grep -E "scenario:|executor:|iteration|data_received|data_sent|http_req_duration|http_reqs|vus:|teardown|setup" || echo "  No execution logs yet"
          
          # Check for any errors or warnings
          echo "Checking for errors/warnings:"
          kubectl logs -n "$NS" "$POD" --tail=100 2>/dev/null | grep -iE "error|warn|fail|exception|panic" | head -5 || echo "  No errors found"
        done
      fi
      
      # Check for k6 test resources and their status
      K6_TESTS=$(kubectl get k6 -A --no-headers 2>/dev/null)
      if [[ -n "$K6_TESTS" ]]; then
        echo ""
        echo "=== k6 Test Resources at $(date '+%H:%M:%S') ==="
        kubectl get k6 -A
        
        # Check if tests are still running
        RUNNING_TESTS=$(echo "$K6_TESTS" | grep -v "finished" | wc -l)
        if [[ "$RUNNING_TESTS" -eq 0 ]]; then
          echo "All k6 tests have finished. Stopping monitoring."
          break
        fi
      fi
      
      # Sleep for 2 minutes before next check (more frequent for better visibility)
      sleep 120
    done
    
    echo "k6 monitoring completed at $(date '+%H:%M:%S')"
  ) &
  K6_MONITOR_PID=$!
  echo "k6 monitoring started with PID: $K6_MONITOR_PID"
}

# Start node failure simulation in background if enabled
start_node_failure_simulation() {
  if [[ "$SIMULATE_NODE_FAILURE" == "true" ]]; then
    echo "Node failure simulation enabled - will terminate a node after ${NODE_FAILURE_DELAY_MINUTES} minutes"
    
    (
      # Wait for specified delay FIRST
      echo "Waiting ${NODE_FAILURE_DELAY_MINUTES} minutes before simulating node failure..."
      sleep $((NODE_FAILURE_DELAY_MINUTES * 60))
      
      echo "=== Starting node failure simulation at $(date '+%H:%M:%S') ==="
      
      # Get nodes running gateway pods
      echo "Finding nodes with gateway pods..."
      GATEWAY_NODES=$(kubectl get pods -n tyk -l app.kubernetes.io/name=tyk-gateway -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' | sort -u)
      
      if [[ -z "$GATEWAY_NODES" ]]; then
        echo "No nodes found with gateway pods, trying to find any pod with 'gateway' in name..."
        GATEWAY_NODES=$(kubectl get pods -n tyk --no-headers | grep gateway | awk '{print $1}' | head -1 | xargs -I {} kubectl get pod {} -n tyk -o jsonpath='{.spec.nodeName}')
      fi
      
      NODE_TO_TERMINATE=$(echo "$GATEWAY_NODES" | head -n 1)
      
      if [[ -z "$NODE_TO_TERMINATE" ]]; then
        echo "No gateway nodes found to terminate"
        exit 0
      fi
      
      echo "Selected node for termination: $NODE_TO_TERMINATE"
      
      # Cloud-specific node termination
      if [[ "${CLOUD:-}" == "Azure" ]]; then
        # Get VMSS instance ID from node name
        VMSS_NAME=$(az vmss list --resource-group "pt-${AZURE_CLUSTER_LOCATION}" --query "[0].name" -o tsv)
        INSTANCE_ID=$(az vmss list-instances --resource-group "pt-${AZURE_CLUSTER_LOCATION}" --name "$VMSS_NAME" --query "[?osProfile.computerName=='$NODE_TO_TERMINATE'].instanceId" -o tsv)
        
        if [[ -n "$INSTANCE_ID" ]]; then
          echo "Terminating Azure VMSS instance: $INSTANCE_ID"
          az vmss delete-instances \
            --resource-group "pt-${AZURE_CLUSTER_LOCATION}" \
            --name "$VMSS_NAME" \
            --instance-ids "$INSTANCE_ID" \
            --no-wait
          echo "Azure node termination initiated"
        else
          echo "Could not find Azure VMSS instance for node: $NODE_TO_TERMINATE"
        fi
        
      elif [[ "${CLOUD:-}" == "AWS" ]]; then
        # Get EC2 instance ID from node provider ID
        INSTANCE_ID=$(kubectl get node "$NODE_TO_TERMINATE" -o jsonpath='{.spec.providerID}' | cut -d'/' -f5)
        
        if [[ -n "$INSTANCE_ID" ]]; then
          echo "Terminating AWS EC2 instance: $INSTANCE_ID"
          aws ec2 terminate-instances \
            --instance-ids "$INSTANCE_ID" \
            --region "${AWS_CLUSTER_LOCATION}"
          echo "AWS node termination initiated"
        else
          echo "Could not find AWS instance ID for node: $NODE_TO_TERMINATE"
        fi
        
      elif [[ "${CLOUD:-}" == "GCP" ]]; then
        # === NODE FAILURE (GKE, with visible node count reduction) ===
        INSTANCE_NAME="$NODE_TO_TERMINATE"
        ZONE="${GCP_CLUSTER_LOCATION}"
        CLUSTER_NAME="pt-${ZONE}"
        
        echo "Node details:"
        echo "  Instance: $INSTANCE_NAME"
        echo "  Zone: $ZONE"
        echo "  Cluster: $CLUSTER_NAME"
        
        # Count pods on the node before deletion
        echo "Pods running on node $INSTANCE_NAME before failure:"
        kubectl get pods --all-namespaces --field-selector spec.nodeName=$INSTANCE_NAME -o wide
        POD_COUNT=$(kubectl get pods --all-namespaces --field-selector spec.nodeName=$INSTANCE_NAME --no-headers | wc -l)
        GATEWAY_POD_COUNT=$(kubectl get pods -n tyk --field-selector spec.nodeName=$INSTANCE_NAME --selector=app=gateway-tyk-tyk-gateway --no-headers | wc -l)
        echo "Total pods on node: $POD_COUNT (Gateway pods: $GATEWAY_POD_COUNT)"
        
        # Check pod distribution across all nodes
        echo "Pod distribution before failure:"
        for node in $(kubectl get nodes -o name | cut -d/ -f2); do
          count=$(kubectl get pods -n tyk --field-selector spec.nodeName=$node --no-headers | wc -l)
          echo "  $node: $count pods"
        done
        
        if [[ -n "$INSTANCE_NAME" ]]; then
          # Resolve the MIG that owns this instance
          MIG_URL=$(gcloud compute instances describe "$INSTANCE_NAME" \
            --zone "$ZONE" --format='get(metadata.items[created-by])')
          MIG_NAME=$(basename "$MIG_URL")
          MIG_SIZE=$(gcloud compute instance-groups managed describe "$MIG_NAME" \
            --zone "$ZONE" --format='get(targetSize)')
          
          echo "=== NODE FAILURE at $(date '+%H:%M:%S') ==="
          echo "Simulating hard failure of $INSTANCE_NAME in MIG $MIG_NAME (drop target size from $MIG_SIZE to $((MIG_SIZE-1)))"
          
          # Identify gateway pods on the soon-to-fail node and remove them fast from endpoints
          GATEWAY_PODS_ON_NODE=$(kubectl get pods -n tyk -l app=gateway-tyk-tyk-gateway -o wide \
            --field-selector spec.nodeName="$INSTANCE_NAME" --no-headers | awk '{print $1}')
          POD_IPS=$(kubectl get pods -n tyk -l app=gateway-tyk-tyk-gateway -o wide \
            --field-selector spec.nodeName="$INSTANCE_NAME" -o jsonpath='{.items[*].status.podIP}')
          
          if [[ -n "$GATEWAY_PODS_ON_NODE" ]]; then
            echo "Force-deleting pods scheduled on $INSTANCE_NAME to drop endpoints immediately:"
            echo "$GATEWAY_PODS_ON_NODE" | xargs -r -n1 -I{} \
              kubectl delete pod -n tyk {} --force --grace-period=0 --wait=false
          else
            echo "No gateway pods found on $INSTANCE_NAME"
          fi
          
          # Delete the instance and reduce MIG target size by 1 (visible node count goes 4 -> 3)
          gcloud compute instance-groups managed delete-instances "$MIG_NAME" \
            --instances="$INSTANCE_NAME" --zone="$ZONE" --quiet
          echo "Deleted instance $INSTANCE_NAME; MIG target size reduced from $MIG_SIZE to $((MIG_SIZE-1))"
          
          # Immediately remove the Node object so 'kubectl get nodes' shows 3, not 3+NotReady
          kubectl delete node "$INSTANCE_NAME" --ignore-not-found=true || true
          
          echo "Node loss triggered - observing brief impact; will resize MIG back to $MIG_SIZE shortly..."
          
          # Optional: Add iptables REJECT rules for guaranteed errors (30-60s)
          if [[ "$GUARANTEE_ERRORS" == "true" ]]; then
            echo "=== Adding iptables REJECT rules for immediate failures ==="
            # Restrict the REJECTs strictly to IPs of pods that were on the failed node
            for n in $(kubectl get nodes -o name | cut -d/ -f2 | grep -v "$INSTANCE_NAME"); do
              echo "Adding REJECT rules on node $n for failed-node pod IPs: $POD_IPS"
              kubectl debug node/$n --profile=sysadmin --image=nicolaka/netshoot -- \
                bash -c "for ip in $POD_IPS; do iptables -I OUTPUT -d \$ip -p tcp -j REJECT --reject-with tcp-reset; done; sleep 60; for ip in $POD_IPS; do iptables -D OUTPUT -d \$ip -p tcp -j REJECT --reject-with tcp-reset; done" &
            done
          fi
          
          # Monitor for the configured downtime duration
          DOWNTIME_MINUTES=$NODE_DOWNTIME_MINUTES
          ITERATIONS=$(( DOWNTIME_MINUTES * 60 / 5 ))
          echo "Monitoring impact for $DOWNTIME_MINUTES minutes ($ITERATIONS checks)..."
          
          for i in $(seq 1 $ITERATIONS); do
            sleep 5
            echo ""
            echo "[$((i*5))s / $(( DOWNTIME_MINUTES * 60 ))s] Impact monitoring:"
            echo "  Node count: $(kubectl get nodes --no-headers | wc -l) (was $MIG_SIZE)"
            kubectl get nodes | grep -E "NAME|NotReady" || echo "    All nodes ready"
            
            echo "  Gateway endpoints ready:"
            ENDPOINT_COUNT=$(kubectl get endpoints -n tyk gateway-tyk-svc-tyk-gateway -o json 2>/dev/null \
              | jq -r '.subsets[0].addresses | length' 2>/dev/null || echo "0")
            echo "    $ENDPOINT_COUNT endpoints"
            
            echo "  Gateway pod phases:"
            kubectl get pods -n tyk -l app=gateway-tyk-tyk-gateway --no-headers \
              | awk '{print $3}' | sort | uniq -c | awk '{print "    "$2": "$1}'
            
            # Show any pods that are not Running
            NOT_RUNNING=$(kubectl get pods -n tyk -l app=gateway-tyk-tyk-gateway --no-headers | grep -v "Running" | wc -l)
            if [[ $NOT_RUNNING -gt 0 ]]; then
              echo "  Non-running gateway pods:"
              kubectl get pods -n tyk -l app=gateway-tyk-tyk-gateway --no-headers | grep -v "Running" | awk '{print "    "$1": "$3}'
            fi
            
            # Check HPA status
            echo "  HPA status:"
            kubectl get hpa -n tyk --no-headers | awk '{print "    "$1": current="$2"/"$3", CPU="$4}'
          done
          
          echo ""
          echo "Resizing MIG $MIG_NAME back to $MIG_SIZE..."
          gcloud compute instance-groups managed resize "$MIG_NAME" --size="$MIG_SIZE" --zone="$ZONE" --quiet
          echo "MIG resized back to $MIG_SIZE - new node will be provisioned"
        else
          echo "Could not find GCP instance for node: $NODE_TO_TERMINATE"
        fi
      fi
      
      echo "=== Node failure simulation completed ==="
      
      # Show cluster status after termination
      sleep 30
      echo "=== Cluster status after node termination ==="
      kubectl get nodes
      echo "=== Gateway pods status ==="
      kubectl get pods -n tyk --selector=app=gateway-tyk-tyk-gateway
    ) &
    
    echo "Node failure simulation scheduled in background"
  fi
}

# Actively wait for a k6 segment CR to finish.
# - Finds the CR by name across all namespaces (field-selector)
# - Polls .status.stage until "finished" (success) or "error" (fail)
# - When cleanup: post is enabled, optionally waits for CR deletion
# Args:
#   $1 - CR name (e.g., test-s1)
#   $2 - timeout in minutes (total wall-clock budget for this segment)
wait_for_k6_segment() {
  local name="$1"
  local timeout_min="$2"
  local deadline=$(( $(date +%s) + timeout_min*60 ))
  local ns="" stage="" prev_stage=""

  echo "Waiting for k6 segment CR '${name}' (timeout: ${timeout_min}m)..."
  while (( $(date +%s) < deadline )); do
    # Remember previous state
    local prev_ns="${ns}" prev_stage_saved="${stage}"
    
    # Determine namespace and stage (try K6 first, then TestRun)
    # Note: field-selector doesn't work reliably with CRDs, using grep instead
    ns="$(kubectl get k6 -A -o json 2>/dev/null | jq -r --arg name "${name}" '.items[] | select(.metadata.name == $name) | .metadata.namespace' | head -1 || true)"
    if [[ -n "${ns}" ]]; then
      stage="$(kubectl get k6 ${name} -n ${ns} -o jsonpath='{.status.stage}' 2>/dev/null || true)"
    else
      ns="$(kubectl get testrun -A -o json 2>/dev/null | jq -r --arg name "${name}" '.items[] | select(.metadata.name == $name) | .metadata.namespace' | head -1 || true)"
      [[ -n "${ns}" ]] && stage="$(kubectl get testrun ${name} -n ${ns} -o jsonpath='{.status.stage}' 2>/dev/null || true)"
    fi
    
    # If CR disappeared but was previously found with 'started' stage, it likely finished
    if [[ -z "${ns}" && -n "${prev_ns}" && "${prev_stage_saved}" == "started" ]]; then
      echo "CR '${name}' disappeared after being in 'started' stage - likely finished and cleaned up by k6-operator"
      return 0
    fi

    if [[ "${stage}" == "finished" ]]; then
      echo "CR '${name}' finished in namespace '${ns}'. Waiting for cleanup (if enabled)..."
      # If cleanup: post is enabled, the operator deletes the CR; tolerate either behavior
      kubectl wait --for=delete k6/${name} -n "${ns}" --timeout=10m 2>/dev/null || \
      kubectl wait --for=delete testrun/${name} -n "${ns}" --timeout=10m 2>/dev/null || true
      return 0
    fi
    if [[ "${stage}" == "error" ]]; then
      echo "CR '${name}' reported stage=error. Describing resource:"
      kubectl describe k6 ${name} -n "${ns}" 2>/dev/null || kubectl describe testrun ${name} -n "${ns}" 2>/dev/null || true
      return 1
    fi
    
    # Show current status every few polls
    if (( $(date +%s) % 60 < 15 )); then  # Show status roughly once per minute
      if [[ -z "${ns}" ]]; then
        echo "  CR '${name}' not found yet. Checking all namespaces... ($(( (deadline - $(date +%s)) / 60 ))m remaining)"
        kubectl get k6 -A 2>/dev/null | grep "${name}" || echo "    No k6 CR matching '${name}' found"
        
      else
        echo "  Current status: namespace='${ns}', stage='${stage}' ($(( (deadline - $(date +%s)) / 60 ))m remaining)"
      fi
    fi
    
    sleep 15
  done
  echo "Timed out waiting for CR '${name}' (last known ns='${ns}', stage='${stage}')."
  return 1
}

# Run segmented tests
run_segmented_tests() {
  # Run the actual tests in 60-minute segments to avoid k6 Prometheus timeout issues
  cd tests
  terraform init
  
  # Calculate number of 60-minute segments needed
  TOTAL_DURATION="$TEST_DURATION_MINUTES"
  SEGMENT_DURATION=60
  
  # Only use segmentation for tests > 60 minutes
  if [[ $TOTAL_DURATION -le $SEGMENT_DURATION ]]; then
    echo "Test duration (${TOTAL_DURATION} min) <= 60 min, running without segmentation"
    NUM_SEGMENTS=1
  else
    NUM_SEGMENTS=$(( (TOTAL_DURATION + SEGMENT_DURATION - 1) / SEGMENT_DURATION ))
    echo "=== Test Segmentation Plan ==="
    echo "Total test duration: ${TOTAL_DURATION} minutes"
    echo "Segment duration: ${SEGMENT_DURATION} minutes"  
    echo "Number of segments: ${NUM_SEGMENTS}"
    echo "Note: Sequential segments to avoid k6 Prometheus timeout (GitHub issue #3498)"
  fi
  
  # Run tests in sequential segments
  for SEGMENT in $(seq 1 $NUM_SEGMENTS); do
    # Calculate duration for this segment
    REMAINING_DURATION=$(( TOTAL_DURATION - (SEGMENT - 1) * SEGMENT_DURATION ))
    
    if [[ $REMAINING_DURATION -lt $SEGMENT_DURATION ]]; then
      # Last segment might be shorter
      CURRENT_DURATION=$REMAINING_DURATION
    else
      CURRENT_DURATION=$SEGMENT_DURATION
    fi
    
    echo ""
    echo "=== Running Test Segment ${SEGMENT}/${NUM_SEGMENTS} ==="
    echo "Segment duration: ${CURRENT_DURATION} minutes"
    echo "Time elapsed: $(( (SEGMENT - 1) * SEGMENT_DURATION )) minutes"
    echo "Time remaining: ${REMAINING_DURATION} minutes"
    K6_NAME="test-s${SEGMENT}"   # must match metadata.name in the Terraform manifest
    
    # Apply terraform with segment-specific variables
    terraform apply \
      --var="kubernetes_config_context=performance-testing" \
      --var="tests_duration=${CURRENT_DURATION}" \
      --var="test_segment=${SEGMENT}" \
      --var="total_segments=${NUM_SEGMENTS}" \
      --auto-approve
    
    # Actively wait for segment completion instead of sleeping the nominal duration.
    # Give each segment a buffer for init/ramp/cleanup; override via BUFFER_MINUTES if needed.
    BUFFER_MINUTES="${BUFFER_MINUTES:-15}"
    SEGMENT_TIMEOUT_MIN=$(( CURRENT_DURATION + BUFFER_MINUTES ))
    echo "Waiting for segment ${SEGMENT} (${K6_NAME}) with timeout ${SEGMENT_TIMEOUT_MIN} minutes..."
    if ! wait_for_k6_segment "${K6_NAME}" "${SEGMENT_TIMEOUT_MIN}"; then
      echo "Segment ${SEGMENT} failed or timed out."
      exit 1
    fi
    
    # Show k6 test status for this segment
    echo "=== Segment ${SEGMENT} Test Status ==="
    kubectl get k6 -A || echo "No k6 resources found"
  done
  
  echo ""
  echo "=== All Test Segments Completed ==="
  echo "Total test time: ${TOTAL_DURATION} minutes across ${NUM_SEGMENTS} segments"
  
  # GUARANTEED SNAPSHOT GENERATION - trigger immediate snapshot now that all tests are done
  echo ""
  echo "=== Triggering Immediate Grafana Snapshot ==="
  echo "All test segments completed, generating snapshot with all collected data..."
  
  # Create a simple immediate snapshot job using kubectl run
  JOB_NAME="snapshot-immediate-$(date +%s)"
  echo "Creating immediate snapshot job: ${JOB_NAME}"
  
  kubectl run "${JOB_NAME}" -n dependencies \
    --image=python:3.9 \
    --restart=Never \
    --rm=false \
    --overrides='{
      "spec": {
        "nodeSelector": {"node": "dependencies"},
        "containers": [{
          "name": "snapshot",
          "image": "python:3.9",
          "command": ["bash", "-c"],
          "args": ["pip install selenium && python /scripts/snapshot.py"],
          "env": [{"name": "TEST_DURATION", "value": "'${TOTAL_DURATION}'"}],
          "volumeMounts": [{"name": "script-volume", "mountPath": "/scripts"}]
        }],
        "volumes": [{
          "name": "script-volume",
          "configMap": {"name": "snapshot-script-configmap"}
        }]
      }
    }' 2>/dev/null && \
    echo "✅ Immediate snapshot job '${JOB_NAME}' created successfully" || \
    echo "⚠️  Failed to create immediate snapshot job, will rely on timed snapshot job"
  
  # Wait for immediate snapshot to complete and show the URL
  if kubectl get pod "${JOB_NAME}" -n dependencies 2>/dev/null; then
    echo "⏳ Waiting for immediate snapshot to complete (up to 5 minutes)..."
    
    # Wait for pod to either succeed or fail (up to 5 minutes)
    WAIT_TIME=0
    while [[ $WAIT_TIME -lt 300 ]]; do
      POD_STATUS=$(kubectl get pod "${JOB_NAME}" -n dependencies -o jsonpath='{.status.phase}' 2>/dev/null || echo "Unknown")
      echo "  Pod status: $POD_STATUS (waited ${WAIT_TIME}s)"
      
      if [[ "$POD_STATUS" == "Succeeded" ]] || [[ "$POD_STATUS" == "Failed" ]] || [[ "$POD_STATUS" == "Completed" ]]; then
        echo "  Pod finished with status: $POD_STATUS"
        break
      fi
      
      sleep 10
      WAIT_TIME=$((WAIT_TIME + 10))
    done
    
    echo "=== Immediate Snapshot Result ==="
    # Get the full logs to find the URL
    FULL_LOGS=$(kubectl logs -n dependencies "${JOB_NAME}" 2>/dev/null || echo "")
    
    # Extract and display the snapshot URL
    SNAPSHOT_URL=$(echo "$FULL_LOGS" | grep -E "https://snapshots\.raintank\.io[^[:space:]]*" | tail -1 || echo "")
    
    if [[ -n "$SNAPSHOT_URL" ]]; then
      echo "✅ GRAFANA SNAPSHOT SUCCESSFULLY GENERATED!"
      echo "================================================"
      echo "🔗 SNAPSHOT URL: $SNAPSHOT_URL"
      echo "================================================"
      echo "📊 Use this link to view your test results in Grafana"
    else
      echo "⚠️  Snapshot job completed but no URL found. Checking logs for errors..."
      echo "Full pod logs:"
      echo "$FULL_LOGS"
      
      # Check if there's an error message
      if echo "$FULL_LOGS" | grep -i "error\|exception\|failed"; then
        echo "❌ Snapshot generation failed with errors above"
      else
        echo "⚠️  Snapshot may still be processing, check 'Test Grafana Snapshot' step later"
      fi
    fi
  fi
}

# Patch Job activeDeadlineSeconds
patch_job_ads() {
  echo ""
  echo "=== Checking k6 Job activeDeadlineSeconds BEFORE patching ==="
  
  # Wait for Jobs to be created with retries
  echo "Waiting for k6 Jobs to be created..."
  for i in {1..30}; do
    JOB_COUNT=$(kubectl get jobs -A -l "k6_cr" --no-headers 2>/dev/null | wc -l)
    if [[ $JOB_COUNT -gt 0 ]]; then
      echo "Found $JOB_COUNT k6 Jobs after $i attempts"
      break
    fi
    echo "  Attempt $i: No Jobs yet, waiting..."
    sleep 2
  done
  
  # First, show current Job ADS values to confirm the issue
  echo "Current k6 Job activeDeadlineSeconds:"
  echo "Runner Jobs:"
  kubectl get jobs -A -l "k6_cr,runner=true" -o json 2>/dev/null \
    | jq -r '.items[] | "  \(.metadata.namespace)/\(.metadata.name): ADS=\(.spec.activeDeadlineSeconds // "not set")"' \
    || echo "  No runner jobs found"
  
  echo "Initializer Jobs:"
  kubectl get jobs -A -l "k6_cr" -o json 2>/dev/null \
    | jq -r '.items[] | select(.metadata.labels["job-name"] // "" | contains("initializer")) | "  \(.metadata.namespace)/\(.metadata.name): ADS=\(.spec.activeDeadlineSeconds // "not set")"' \
    || echo "  No initializer jobs found"
  
  echo "Starter Jobs:"
  kubectl get jobs -A -l "k6_cr" -o json 2>/dev/null \
    | jq -r '.items[] | select(.metadata.labels["job-name"] // "" | contains("starter")) | "  \(.metadata.namespace)/\(.metadata.name): ADS=\(.spec.activeDeadlineSeconds // "not set")"' \
    || echo "  No starter jobs found"
  
  # Check if we found the 3600s issue
  RUNNER_ADS=$(kubectl get jobs -A -l "k6_cr,runner=true" -o json 2>/dev/null \
    | jq -r '.items[] | .spec.activeDeadlineSeconds // 0' | sort -u)
  if echo "$RUNNER_ADS" | grep -q "^3600$"; then
    echo ""
    echo "🔴 CONFIRMED: Found Jobs with activeDeadlineSeconds=3600 (1 hour limit)"
    echo "This explains why tests stop at exactly 60 minutes!"
  fi
  
  # === Attempt to patch Job activeDeadlineSeconds ===
  DESIRED_ADS=$(( TEST_DURATION_MINUTES * 60 + 1800 ))
  echo "Desired activeDeadlineSeconds: $DESIRED_ADS seconds ($(( TEST_DURATION_MINUTES + 30 )) minutes)"
  
  echo ""
  echo "=== Attempting to patch Job activeDeadlineSeconds ==="
  echo "Target: ${DESIRED_ADS}s (test duration + 30min buffer)"
  
  # Patch all k6 Jobs
  PATCHED_JOBS=0
  FAILED_JOBS=0
  
  for job_info in $(kubectl get jobs -A -l "k6_cr" -o json | jq -r '.items[] | "\(.metadata.namespace):\(.metadata.name)"'); do
    ns=$(echo "$job_info" | cut -d':' -f1)
    name=$(echo "$job_info" | cut -d':' -f2)
    
    echo "Patching Job $ns/$name..."
    if kubectl patch job -n "$ns" "$name" --type merge -p "{\"spec\":{\"activeDeadlineSeconds\":$DESIRED_ADS}}" 2>/dev/null; then
      echo "✅ Successfully patched $ns/$name"
      PATCHED_JOBS=$((PATCHED_JOBS + 1))
    else
      echo "⚠️ Failed to patch $ns/$name (field may be immutable)"
      FAILED_JOBS=$((FAILED_JOBS + 1))
    fi
  done
  
  echo ""
  echo "=== Job Patching Summary ==="
  echo "Patched successfully: $PATCHED_JOBS jobs"
  echo "Failed to patch: $FAILED_JOBS jobs"
  
  # Verify patching results
  echo ""
  echo "=== Job activeDeadlineSeconds AFTER patching ==="
  kubectl get jobs -A -l "k6_cr" -o json | jq -r '.items[] | "  \(.metadata.namespace)/\(.metadata.name): ADS=\(.spec.activeDeadlineSeconds // "not set")"'
  
  # Final warning about potential 1-hour cutoff
  FINAL_RUNNER_ADS=$(kubectl get jobs -A -l "k6_cr,runner=true" -o json 2>/dev/null \
    | jq -r '.items[] | .spec.activeDeadlineSeconds // 0' | sort -u)
  
  if echo "$FINAL_RUNNER_ADS" | grep -q "^3600$"; then
    echo ""
    echo "⚠️⚠️⚠️ CRITICAL WARNING ⚠️⚠️⚠️"
    echo "Some Jobs still have activeDeadlineSeconds=3600 (1 hour)"
    
    for ads in $FINAL_RUNNER_ADS; do
      if [[ "$ads" == "3600" ]]; then
        echo "⚠️  Test will likely stop at $(( ads / 60 )) minutes instead of $TEST_DURATION_MINUTES minutes"
      fi
    done
    echo "⚠️⚠️⚠️ END WARNING ⚠️⚠️⚠️"
  else
    echo "✅ All Jobs have appropriate activeDeadlineSeconds values"
  fi
}

# Main execution
main() {
  echo "=== Starting Segmented k6 Test Execution ==="
  
  # Start monitoring
  start_k6_monitoring
  
  # Start node failure simulation if enabled
  start_node_failure_simulation
  
  # Run the segmented tests
  run_segmented_tests
  
  # Patch Job activeDeadlineSeconds (for future reference)
  patch_job_ads
  
  echo ""
  echo "=== Segmented Test Execution Completed ==="
  echo "Test duration: ${TEST_DURATION_MINUTES} minutes"
  echo "All segments completed successfully"
}

# Run main function
main "$@"