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
  const baseScenario = getScenarios(${jsonencode(var.config)})[SCENARIO || "constant-arrival-rate"];
  const baseDuration = ${var.config.duration};
  
  // Simple 3-phase scaling test: 10min baseline, 10min scaled, 10min final
  const phaseLength = Math.floor(baseDuration / 3) * 60; // Convert to seconds and divide by 3
  const scaleOpTime = 30; // 30 seconds per scale operation
  
  return {
    baseline_load: {
      ...baseScenario,
      exec: 'loadTest',
      startTime: '0s',
      duration: phaseLength + 's',
      tags: { phase: 'baseline' },
    },
    scale_up_trigger: {
      executor: 'constant-vus',
      vus: 1,
      duration: scaleOpTime + 's',
      exec: 'scaleUp',
      startTime: phaseLength + 's',
      tags: { phase: 'scale_up' },
    },
    scaled_load: {
      ...baseScenario,
      exec: 'loadTest',
      startTime: (phaseLength + scaleOpTime) + 's',
      duration: phaseLength + 's',
      tags: { phase: 'scaled' },
    },
    scale_down_trigger: {
      executor: 'constant-vus',
      vus: 1,
      duration: scaleOpTime + 's',
      exec: 'scaleDown',
      startTime: (phaseLength * 2 + scaleOpTime) + 's',
      tags: { phase: 'scale_down' },
    },
    final_load: {
      ...baseScenario,
      exec: 'loadTest',
      startTime: (phaseLength * 2 + scaleOpTime * 2) + 's',
      duration: phaseLength + 's',
      tags: { phase: 'final' },
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

export function scaleUp(keys) {
  console.log('Triggering scale-up: Adding 2 nodes to ${var.name} node group');
  
  // Call scaling webhook or kubectl command
  const scaleResponse = http.post('http://scaling-webhook.dependencies.svc:8080/scale', 
    JSON.stringify({
      action: 'scale_up',
      target: '${var.name}',
      nodes_to_add: 2,
      cluster_type: __ENV.CLUSTER_TYPE || 'eks'
    }), {
      headers: { 'Content-Type': 'application/json' },
      timeout: '60s'
    }
  );
  
  check(scaleResponse, {
    'scale-up request sent': (r) => r.status === 200 || r.status === 202,
  });
  
  // Wait for nodes to be ready
  sleep(20);
  console.log('Scale-up operation initiated');
}

export function scaleDown(keys) {
  console.log('Triggering scale-down: Removing 2 nodes from ${var.name} node group');
  
  // Call scaling webhook or kubectl command
  const scaleResponse = http.post('http://scaling-webhook.dependencies.svc:8080/scale',
    JSON.stringify({
      action: 'scale_down', 
      target: '${var.name}',
      nodes_to_remove: 2,
      cluster_type: __ENV.CLUSTER_TYPE || 'eks'
    }), {
      headers: { 'Content-Type': 'application/json' },
      timeout: '60s'
    }
  );
  
  check(scaleResponse, {
    'scale-down request sent': (r) => r.status === 200 || r.status === 202,
  });
  
  // Wait for scale-down to complete
  sleep(20);
  console.log('Scale-down operation initiated');
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