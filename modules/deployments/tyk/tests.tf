module "tests" {
  source           = "../dependencies/k6/tests"
  namespace        = var.namespace
  analytics        = var.analytics
  auth             = var.auth
  quota            = var.quota
  rate_limit       = var.rate_limit
  open_telemetry   = var.open_telemetry
  header_injection = var.header_injection
  service          = var.service

  depends_on = [kubernetes_namespace.tyk]
}

module "scenarios" {
  source    = "../dependencies/k6/scenarios"
  namespace = var.namespace

  depends_on = [kubernetes_namespace.tyk]
}

data "kubernetes_secret" "tyk-operator-conf" {
  metadata {
    name      = "tyk-operator-conf"
    namespace = var.namespace
  }

  depends_on = [kubernetes_namespace.tyk, helm_release.tyk]
}

resource "kubernetes_config_map" "auth-configmap" {
  metadata {
    name      = "auth-configmap"
    namespace = var.namespace
  }

  depends_on = [kubernetes_namespace.tyk, data.kubernetes_secret.tyk-operator-conf]
  data = {
    "auth.js" = <<EOF
import http from 'k6/http';
import { fail, sleep } from 'k6';
import { b64encode } from 'k6/encoding';

const base64UrlEncode = (str) => {
  return b64encode(str).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

// use_config_maps_for_apis=true mounts APIs/policies straight onto the
// Gateway's filesystem (TYK_GW_USEDBAPPCONFIGS=false, policy source=file).
// The Dashboard never learns about those, so keys must be created directly
// against the Gateway's own admin API instead of the Dashboard's.
const USE_GATEWAY_KEY_API = ${var.use_config_maps_for_apis};

const dashboardParams = {
  responseType: 'text',
  headers: {
    'Authorization': "${data.kubernetes_secret.tyk-operator-conf.data["TYK_AUTH"]}",
    'Content-Type': 'application/json',
  },
};

const gatewayParams = {
  responseType: 'text',
  headers: {
    'x-tyk-authorization': "${local.gateway-secret}",
    'Content-Type': 'application/json',
  },
};

const APP_COUNT = ${var.service.app_count};
const NAMESPACE = "${var.namespace}";
const BATCH_SIZE = 50;
const MAX_RETRIES = 3;
const TOLERANCE_PCT = 1;
const PROGRESS_EVERY = 1000;

const buildCreateRequest = (baseURL, i) => {
  if (USE_GATEWAY_KEY_API) {
    const policyId = "api-policy-" + (i % APP_COUNT);
    const payload = JSON.stringify({
      "org_id": "1",
      "allowance": -1,
      "rate": -1,
      "per": -1,
      "throttle_interval": -1,
      "quota_max": -1,
      "apply_policies": [ policyId ],
    });
    return ['POST', baseURL + '/tyk/keys/create', payload, gatewayParams];
  }
  const policyId = base64UrlEncode(NAMESPACE + "/api-policy-" + (i % APP_COUNT));
  const payload = JSON.stringify({
    "allowance": -1,
    "rate": -1,
    "per": -1,
    "throttle_interval": -1,
    "quota_max": -1,
    "apply_policies": [ policyId ],
  });
  return ['POST', baseURL + '/api/keys', payload, dashboardParams];
};

const generateKeys = (keyCount) => {
  const baseURL = USE_GATEWAY_KEY_API
    ? "http://gateway-svc-tyk-tyk-gateway:8080"
    : "http://dashboard-svc-tyk-tyk-dashboard:3000";
  const keys = new Array(keyCount);
  let failedCount = 0;
  const startMs = Date.now();
  let nextProgressAt = PROGRESS_EVERY;

  for (let batchStart = 0; batchStart < keyCount; batchStart += BATCH_SIZE) {
    const batchEnd = Math.min(batchStart + BATCH_SIZE, keyCount);
    let requests = [];
    let indices = [];
    for (let i = batchStart; i < batchEnd; i++) {
      requests.push(buildCreateRequest(baseURL, i));
      indices.push(i);
    }

    for (let attempt = 0; attempt <= MAX_RETRIES; attempt++) {
      const responses = http.batch(requests);
      const retryRequests = [];
      const retryIndices = [];
      for (let r = 0; r < responses.length; r++) {
        if (responses[r].status === 200) {
          const body = responses[r].json();
          keys[indices[r]] = USE_GATEWAY_KEY_API ? body.key : body.key_id;
        } else if (attempt < MAX_RETRIES) {
          retryRequests.push(requests[r]);
          retryIndices.push(indices[r]);
        } else {
          failedCount++;
          console.warn("generateKeys: key #" + indices[r] + " failed after " + MAX_RETRIES + " retries (status=" + responses[r].status + ", body=" + (responses[r].body || "").slice(0, 200) + ")");
        }
      }
      if (retryRequests.length === 0) break;
      sleep(0.1 * Math.pow(2, attempt));
      requests = retryRequests;
      indices = retryIndices;
    }

    if (batchEnd >= nextProgressAt || batchEnd === keyCount) {
      const elapsedSec = ((Date.now() - startMs) / 1000).toFixed(1);
      console.log("generateKeys: " + batchEnd + "/" + keyCount + " processed (" + failedCount + " failed), elapsed " + elapsedSec + "s");
      while (nextProgressAt <= batchEnd) nextProgressAt += PROGRESS_EVERY;
    }
  }

  const successfulKeys = keys.filter((k) => k !== undefined);
  const failurePct = (failedCount / keyCount) * 100;
  if (failurePct > TOLERANCE_PCT) {
    fail("generateKeys: " + failedCount + "/" + keyCount + " (" + failurePct.toFixed(2) + "%) keys failed after " + MAX_RETRIES + " retries; exceeds tolerance " + TOLERANCE_PCT + "%");
  }
  if (failedCount > 0) {
    console.warn("generateKeys: " + failedCount + "/" + keyCount + " (" + failurePct.toFixed(2) + "%) keys failed but within tolerance " + TOLERANCE_PCT + "%; proceeding with " + successfulKeys.length + " keys");
  }
  return successfulKeys;
};

export { generateKeys };
EOF
  }
}