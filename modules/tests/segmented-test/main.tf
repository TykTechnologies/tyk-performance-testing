terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.4"
    }
  }
}

# For 5-hour test, create 5 x 60-minute segments
locals {
  total_duration = var.config.duration
  segment_duration = min(60, var.config.duration) # 60 minutes max per segment
  num_segments = ceil(var.config.duration / local.segment_duration)
}

# Create multiple k6 test segments
resource "kubectl_manifest" "test_segment" {
  count = local.num_segments

  yaml_body = <<YAML
apiVersion: k6.io/v1alpha1
kind: K6
metadata:
  name: test-segment-${count.index}
  namespace: ${var.name}
spec:
  parallelism: ${var.config.parallelism}
  separate: false
  quiet: "false"
  cleanup: "post"
  activeDeadlineSeconds: ${(local.segment_duration * 60) + 600}  # segment duration + 10 min buffer
  arguments: --out experimental-prometheus-rw --tag testid=${var.name}-seg${count.index} --tag segment=${count.index} --env SCENARIO=${var.config.executor} --env DURATION_MINUTES=${local.segment_duration} --no-thresholds --summary-mode=disabled
  # Add start delay for sequential execution
  startAfter: ${count.index * local.segment_duration * 60}  # Start each segment after previous completes
  runner:
    env:
    - name: K6_PROMETHEUS_RW_SERVER_URL
      value: http://prometheus-server.dependencies.svc:80/api/v1/write
    - name: K6_PROMETHEUS_RW_TREND_STATS
      value: p(75),p(90),p(95),p(99)
    - name: K6_PROMETHEUS_RW_STALE_MARKERS
      value: "false"
    - name: K6_PROMETHEUS_RW_PUSH_INTERVAL
      value: "5s"
    - name: DURATION_MINUTES
      value: "${local.segment_duration}"
    - name: SEGMENT_INDEX
      value: "${count.index}"
    - name: TOTAL_SEGMENTS
      value: "${local.num_segments}"
  script:
    configMap:
      name: test-${var.name}-configmap
      file: script.js
YAML

  depends_on = [kubernetes_config_map.test-configmap]
}

# Update Grafana queries to handle segmented tests
resource "kubernetes_config_map" "grafana_queries" {
  metadata {
    name      = "grafana-queries"
    namespace = var.name
  }

  data = {
    # Combine metrics from all segments
    rps_query = <<EOF
sum by(testid) (
  rate(k6_http_reqs_total{testid=~"${var.name}-seg.*", group!="::setup"}[30s])
)
EOF

    latency_query = <<EOF
avg by(testid) (
  k6_http_req_duration_p75{testid=~"${var.name}-seg.*", group!="::setup"}
)
EOF
  }
}
