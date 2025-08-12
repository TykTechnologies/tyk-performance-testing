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

const { SCENARIO, SCALING_ENABLED } = __ENV;

export const options = {
  discardResponseBodies: true,
  insecureSkipTLSVerify: true,
  setupTimeout: '300s',
  scenarios: SCALING_ENABLED === "true" ? getScalingScenarios() : { [SCENARIO]: getScenarios(${jsonencode(var.config)})[SCENARIO] },
  thresholds: {
    'http_req_duration': ['p(95)<2000'],
    'http_req_failed': ['rate<0.05'],
  },
};

function getScalingScenarios() {
  const baseDuration = ${var.config.duration};
  const baseRate = ${var.config.rate};
  const baseVUs = ${var.config.virtual_users};
  
  // Autoscaling test: gradually increase load to trigger scaling, then decrease
  // Phase 1: 10min baseline (normal load)
  // Phase 2: 10min high load (3x traffic to trigger scale-up)
  // Phase 3: 10min baseline (back to normal, triggers scale-down)
  
  return {
    baseline_phase: {
      executor: 'ramping-arrival-rate',
      startRate: Math.floor(baseRate * 0.5),
      timeUnit: '1s',
      preAllocatedVUs: baseVUs,
      maxVUs: baseVUs * 4,
      stages: [
        { target: baseRate, duration: '1m' },           // Ramp up to baseline
        { target: baseRate, duration: '9m' },           // Hold baseline for 9 minutes
      ],
      exec: 'loadTest',
      startTime: '0s',
      tags: { phase: 'baseline' },
    },
    scale_up_phase: {
      executor: 'ramping-arrival-rate',
      startRate: baseRate,
      timeUnit: '1s',
      preAllocatedVUs: baseVUs * 2,
      maxVUs: baseVUs * 6,
      stages: [
        { target: baseRate * 3, duration: '2m' },       // Ramp up to 3x load
        { target: baseRate * 3, duration: '8m' },       // Hold high load for 8 minutes
      ],
      exec: 'loadTest',
      startTime: '10m',
      tags: { phase: 'scale_up' },
    },
    scale_down_phase: {
      executor: 'ramping-arrival-rate',
      startRate: baseRate * 3,
      timeUnit: '1s',
      preAllocatedVUs: baseVUs * 2,
      maxVUs: baseVUs * 4,
      stages: [
        { target: baseRate, duration: '2m' },           // Ramp down to baseline
        { target: baseRate, duration: '8m' },           // Hold baseline for 8 minutes
      ],
      exec: 'loadTest',
      startTime: '20m',
      tags: { phase: 'scale_down' },
    }
  };
}

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
  loadTest(keys);
}

export function loadTest(keys) {
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

// Autoscaling is now handled by Kubernetes Cluster Autoscaler
// The increased traffic in scale_up_phase will cause pods to need more resources,
// triggering the cluster autoscaler to add nodes automatically.
// When traffic decreases in scale_down_phase, the autoscaler will remove unneeded nodes.
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
  arguments: --out experimental-prometheus-rw --tag testid=${var.name} --env SCENARIO=${var.config.executor} --env SCALING_ENABLED=${var.scaling_enabled} --env CLUSTER_TYPE=${var.cluster_type}
  initializer:
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
    nodeSelector:
      node: ${var.name}-tests
  runner:
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
  script:
    configMap:
      name: test-${var.name}-configmap
      file: script.js
YAML

  depends_on = [kubernetes_config_map.test-configmap]
}