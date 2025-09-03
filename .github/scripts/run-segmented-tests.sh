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
      echo "Waiting ${NODE_FAILURE_DELAY_MINUTES} minutes before simulating node failure..."
      sleep $((NODE_FAILURE_DELAY_MINUTES * 60))
      
      echo ""
      echo "=== Starting Node Failure Simulation at $(date '+%H:%M:%S') ==="
      
      # Get list of worker nodes (exclude master nodes)
      WORKER_NODES=$(kubectl get nodes --no-headers | grep -v "master\|control-plane" | awk '{print $1}')
      
      if [[ -z "$WORKER_NODES" ]]; then
        echo "❌ No worker nodes found for termination"
        exit 1
      fi
      
      # Select a random worker node for termination
      NODE_TO_TERMINATE=$(echo "$WORKER_NODES" | shuf -n 1)
      echo "🎯 Selected node for termination: $NODE_TO_TERMINATE"
      
      # Show current k6 pod distribution before failure
      echo ""
      echo "Pod distribution before node failure:"
      kubectl get pods -A -o wide | grep k6 || echo "No k6 pods found"
      
      # Terminate the node based on cloud provider
      if [[ "${CLOUD:-}" == "Azure" ]]; then
        echo "Terminating Azure VMSS instance for node: $NODE_TO_TERMINATE"
        VMSS_NAME=$(az vmss list --resource-group "pt-${AZURE_CLUSTER_LOCATION}" --query "[0].name" -o tsv)
        INSTANCE_ID=$(az vmss list-instances --resource-group "pt-${AZURE_CLUSTER_LOCATION}" --name "$VMSS_NAME" --query "[?osProfile.computerName=='$NODE_TO_TERMINATE'].instanceId" -o tsv)
        
        if [[ -n "$INSTANCE_ID" ]]; then
          az vmss delete-instances \
            --resource-group "pt-${AZURE_CLUSTER_LOCATION}" \
            --name "$VMSS_NAME" \
            --instance-ids "$INSTANCE_ID" \
            --no-wait
          echo "✅ Azure VMSS instance $INSTANCE_ID terminated"
        else
          echo "❌ Could not find Azure VMSS instance for node $NODE_TO_TERMINATE"
        fi
      elif [[ "${CLOUD:-}" == "AWS" ]]; then
        echo "Terminating AWS EC2 instance for node: $NODE_TO_TERMINATE"
        # Get the instance ID from the node's provider ID
        INSTANCE_ID=$(kubectl get node "$NODE_TO_TERMINATE" -o jsonpath='{.spec.providerID}' | sed 's/.*\///')
        
        if [[ -n "$INSTANCE_ID" ]]; then
          aws ec2 terminate-instances \
            --instance-ids "$INSTANCE_ID" \
            --region "${AWS_CLUSTER_LOCATION}"
          echo "✅ AWS EC2 instance $INSTANCE_ID terminated"
        else
          echo "❌ Could not find AWS EC2 instance for node $NODE_TO_TERMINATE"
        fi
      elif [[ "${CLOUD:-}" == "GCP" ]]; then
        echo "Terminating GCP instance for node: $NODE_TO_TERMINATE"
        INSTANCE_NAME=$(echo "$NODE_TO_TERMINATE" | sed 's/gke-.*//' | sed 's/-[^-]*$//')
        ZONE="${GCP_CLUSTER_LOCATION}"
        
        gcloud compute instances delete "$INSTANCE_NAME" \
          --zone="$ZONE" \
          --quiet
        echo "✅ GCP instance $INSTANCE_NAME terminated"
      else
        echo "❌ Unknown cloud provider for node termination"
      fi
      
      echo ""
      echo "Node $NODE_TO_TERMINATE termination initiated at $(date '+%H:%M:%S')"
      echo "Monitoring cluster recovery..."
      
      # Wait and monitor the recovery
      for i in {1..60}; do  # Monitor for up to 10 minutes
        sleep 10
        
        # Check node status
        NODE_STATUS=$(kubectl get node "$NODE_TO_TERMINATE" --no-headers 2>/dev/null | awk '{print $2}' || echo "NotFound")
        
        # Check if k6 pods are still running
        K6_PODS=$(kubectl get pods -A --no-headers | grep k6 | wc -l)
        RUNNING_K6_PODS=$(kubectl get pods -A --no-headers | grep k6 | grep Running | wc -l)
        
        echo "Recovery check $i/60: Node: $NODE_STATUS, k6 pods: $RUNNING_K6_PODS/$K6_PODS running"
        
        # If guarantee_errors is enabled, look for specific error conditions
        if [[ "$GUARANTEE_ERRORS" == "true" ]]; then
          # Check for any failed HTTP requests in k6 logs
          K6_ERRORS=$(kubectl logs -l k6_cr=tyk-test --tail=100 | grep -i "request_failed\|connection.*refused\|timeout" | wc -l 2>/dev/null || echo "0")
          if [[ "$K6_ERRORS" -gt 0 ]]; then
            echo "✅ Detected $K6_ERRORS error conditions - node failure impact confirmed"
            break
          fi
        fi
        
        # Stop monitoring after specified downtime
        if [[ $i -ge $((NODE_DOWNTIME_MINUTES * 6)) ]]; then  # 6 checks per minute
          break
        fi
      done
      
      # Final status
      echo ""
      echo "=== Node Failure Simulation Completed at $(date '+%H:%M:%S') ==="
      echo "Final cluster state:"
      kubectl get nodes --no-headers | grep -v "master\|control-plane" || echo "No worker nodes found"
      
      FINAL_K6_PODS=$(kubectl get pods -A --no-headers | grep k6 | grep Running | wc -l)
      echo "Final k6 pods running: $FINAL_K6_PODS"
      
    ) &
    NODE_FAILURE_PID=$!
    echo "Node failure simulation scheduled with PID: $NODE_FAILURE_PID"
  fi
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
    
    # Apply terraform with segment-specific variables
    terraform apply \
      --var="kubernetes_config_context=performance-testing" \
      --var="tests_duration=${CURRENT_DURATION}" \
      --var="test_segment=${SEGMENT}" \
      --var="total_segments=${NUM_SEGMENTS}" \
      --auto-approve
    
    # Wait for segment to complete
    echo "Waiting for segment ${SEGMENT} to complete (${CURRENT_DURATION} minutes)..."
    sleep $(( CURRENT_DURATION * 60 ))
    
    # Show k6 test status for this segment
    echo "=== Segment ${SEGMENT} Test Status ==="
    kubectl get k6 -A || echo "No k6 resources found"
  done
  
  echo ""
  echo "=== All Test Segments Completed ==="
  echo "Total test time: ${TOTAL_DURATION} minutes across ${NUM_SEGMENTS} segments"
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