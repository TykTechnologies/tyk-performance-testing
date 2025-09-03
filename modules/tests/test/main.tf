terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.4"
    }
  }
}

resource "kubernetes_config_map" "test-configmap" {
  metadata {
    name      = "test-${var.name}-configmap"
    namespace = var.name
  }

  data = {
    "script.js" = <<EOF
import http from 'k6/http';
import { check, sleep } from 'k6';
import { getAuth, getAuthType, getRouteCount, getHostCount, generateJWTRSAKeys, generateJWTHMACKeys, addTestInfoMetrics } from "/helpers/tests.js";
import { getScenarios } from "/helpers/scenarios.js";
import { generateKeys } from "/helpers/auth.js";

const { SCENARIO } = __ENV;

// Calculate setup timeout based on test duration (minimum 300s, scales with duration)
const setupTimeoutSeconds = Math.max(300, ${var.config.duration} * 60 * 0.1); // 10% of test duration or 300s minimum

export const options = {
  discardResponseBodies: true,
  insecureSkipTLSVerify: true,
  setupTimeout: setupTimeoutSeconds + 's',
  scenarios: { [SCENARIO]: getScenarios(${jsonencode(var.config)})[SCENARIO] },
  thresholds: {
    'http_req_duration': ['p(95)<2000'],
    'http_req_failed': ['rate<0.05'],
  },
};

export function setup() {
  addTestInfoMetrics(${jsonencode(var.config)}, ${var.config.auth.key_count});
  if (getAuth()) {
    if ("JWT-RSA" === getAuthType()) {
      return generateJWTRSAKeys(${var.config.auth.key_count})
    } else if ("JWT-HMAC" === getAuthType()) {
      return generateJWTHMACKeys(${var.config.auth.key_count})
    }
    return generateKeys(${var.config.auth.key_count})
  }
  return {};
}

export default function (keys) {
  const routeCount = getRouteCount();
  let i = Math.floor(Math.random() * routeCount);

  let headers = {};
  if (getAuth()) {
    headers = { "Authorization": keys[i % keys.length] }
  }

  let url = "http://${var.service_name}.${var.name}.svc:${var.service_port}/api-" + i + "/?${var.config.fortio_options}";
  if (${"upstream" == var.name}) {
    i = Math.floor(Math.random() * getHostCount());
    url = "http://${var.service_name}-" + i + ".${var.name}.svc:${var.service_port}/?${var.config.fortio_options}"
  }

  const response = http.get(url, { headers });
  check(response, {
    'status is 200': (r) => r.status === 200,
  });
}
EOF
  }
}

resource "kubectl_manifest" "test" {
  yaml_body = <<YAML
apiVersion: k6.io/v1alpha1
kind: K6
metadata:
  name: test
  namespace: ${var.name}
spec:
  parallelism: ${var.config.parallelism}
  separate: false
  quiet: "false"
  cleanup: "post"
  # Add activeDeadlineSeconds to ensure job can run for full duration
  activeDeadlineSeconds: ${(var.config.duration * 60) + 1800}  # duration in seconds + 30 min buffer
  # IMPORTANT: pass duration to BOTH initializer (inspect) and runner (run)
  arguments: --out experimental-prometheus-rw --tag testid=${var.name} --env SCENARIO=${var.config.executor} --env DURATION_MINUTES=${var.config.duration} --no-thresholds --no-summary
  initializer:
    activeDeadlineSeconds: ${(var.config.duration * 60) + 1800}  # Prevent 90m cutoff
    # Ensure initializer sees DURATION_MINUTES for proper test duration planning
    env:
    - name: DURATION_MINUTES
      value: "${var.config.duration}"
    metadata:
      labels:
        initializer: "k6"
    volumes:
    - name: tests
      configMap:
        name: tests-configmap
    - name: scenarios
      configMap:
        name: scenarios-configmap
    - name: auth
      configMap:
        name: auth-configmap
    volumeMounts:
    - name: tests
      mountPath: /helpers/tests.js
      subPath: tests.js
    - name: scenarios
      mountPath: /helpers/scenarios.js
      subPath: scenarios.js
    - name: auth
      mountPath: /helpers/auth.js
      subPath: auth.js
    nodeSelector:
      node: ${var.name}-tests
    affinity:
      podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
        - topologyKey: kubernetes.io/hostname
          labelSelector:
            matchExpressions:
            - key: initializer
              operator: In
              values:
              - "k6"
        - topologyKey: kubernetes.io/hostname
          labelSelector:
            matchExpressions:
            - key: runner
              operator: In
              values:
              - "true"
  starter:
    activeDeadlineSeconds: ${(var.config.duration * 60) + 1800}  # Prevent 90m cutoff
    nodeSelector:
      node: ${var.name}-tests
  runner:
    # Ensure runner pods don't timeout
    activeDeadlineSeconds: ${(var.config.duration * 60) + 1800}  # duration in seconds + 30 min buffer
    volumes:
    - name: tests
      configMap:
        name: tests-configmap
    - name: scenarios
      configMap:
        name: scenarios-configmap
    - name: auth
      configMap:
        name: auth-configmap
    volumeMounts:
    - name: tests
      mountPath: /helpers/tests.js
      subPath: tests.js
    - name: scenarios
      mountPath: /helpers/scenarios.js
      subPath: scenarios.js
    - name: auth
      mountPath: /helpers/auth.js
      subPath: auth.js
    nodeSelector:
      node: ${var.name}-tests
    env:
    - name: K6_PROMETHEUS_RW_SERVER_URL
      value: http://prometheus-server.dependencies.svc:80/api/v1/write
    - name: K6_PROMETHEUS_RW_TREND_STATS
      value: p(75),p(90),p(95),p(99)
    - name: K6_PROMETHEUS_RW_STALE_MARKERS
      value: "false"  # Disable stale markers to prevent 1-hour cutoff
    - name: K6_PROMETHEUS_RW_PUSH_INTERVAL
      value: "5s"  # Push metrics more frequently to prevent gaps
    - name: K6_PROMETHEUS_RW_INSECURE_SKIP_TLS_VERIFY
      value: "true"
    - name: K6_PROMETHEUS_RW_TREND_AS_NATIVE_HISTOGRAM
      value: "false"  # Use traditional histograms for better Grafana compatibility
    # Additional settings to prevent metric timeouts in long tests
    - name: K6_PROMETHEUS_RW_MAX_SAMPLES_PER_SEND
      value: "1000"  # Reduce batch size to prevent timeouts
    - name: K6_PROMETHEUS_RW_TIMEOUT
      value: "30s"  # Explicit timeout per remote write request
    - name: K6_LOG_LEVEL
      value: "info"  # Enable logging to debug metric issues
    - name: DURATION_MINUTES
      value: "${var.config.duration}"
  script:
    configMap:
      name: test-${var.name}-configmap
      file: script.js
YAML

  depends_on = [kubernetes_config_map.test-configmap]
}