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

  depends_on = [kubernetes_namespace.kong]
}

module "scenarios" {
  source    = "../dependencies/k6/scenarios"
  namespace = var.namespace

  depends_on = [kubernetes_namespace.kong]
}

resource "kubernetes_config_map" "auth-configmap" {
  metadata {
    name      = "auth-configmap"
    namespace = var.namespace
  }

  data = {
    "auth.js" = <<EOF
import http from 'k6/http';
import { check, fail, sleep } from 'k6';

const params = {
  responseType: 'text',
  headers: {
    'Content-Type': 'application/json',
  },
};

const APP_COUNT = ${var.service.app_count};
const BATCH_SIZE = 50;
const MAX_RETRIES = 3;
const TOLERANCE_PCT = 1;
const PROGRESS_EVERY = 1000;

const createConsumers = (baseURL, appCount) => {
  // appCount is small (bounded by service_app_count) - sequential is fine
  for (let i = 0; i < appCount; i++) {
    const payload = JSON.stringify({ username: 'app-' + i });
    const res = http.post(baseURL + '/consumers/', payload, params);
    check(res, {
      ['consumer "app-' + i + '" creation status is 201/409']: (r) => r.status === 201 || r.status === 409,
    }) || fail('Failed to create consumer "app-' + i + '"');
  }
};

const buildKeyRequest = (baseURL, i) => {
  return ['POST', baseURL + '/consumers/app-' + (i % APP_COUNT) + '/key-auth/', JSON.stringify({}), params];
};

const createKeys = (baseURL, keyCount) => {
  const keys = new Array(keyCount);
  let failedCount = 0;
  const startMs = Date.now();
  let nextProgressAt = PROGRESS_EVERY;

  for (let batchStart = 0; batchStart < keyCount; batchStart += BATCH_SIZE) {
    const batchEnd = Math.min(batchStart + BATCH_SIZE, keyCount);
    let requests = [];
    let indices = [];
    for (let i = batchStart; i < batchEnd; i++) {
      requests.push(buildKeyRequest(baseURL, i));
      indices.push(i);
    }

    for (let attempt = 0; attempt <= MAX_RETRIES; attempt++) {
      const responses = http.batch(requests);
      const retryRequests = [];
      const retryIndices = [];
      for (let r = 0; r < responses.length; r++) {
        if (responses[r].status === 201) {
          keys[indices[r]] = responses[r].json().key;
        } else if (attempt < MAX_RETRIES) {
          retryRequests.push(requests[r]);
          retryIndices.push(indices[r]);
        } else {
          failedCount++;
          console.warn("createKeys: key #" + indices[r] + " failed after " + MAX_RETRIES + " retries (status=" + responses[r].status + ", body=" + (responses[r].body || "").slice(0, 200) + ")");
        }
      }
      if (retryRequests.length === 0) break;
      sleep(0.1 * Math.pow(2, attempt));
      requests = retryRequests;
      indices = retryIndices;
    }

    if (batchEnd >= nextProgressAt || batchEnd === keyCount) {
      const elapsedSec = ((Date.now() - startMs) / 1000).toFixed(1);
      console.log("createKeys: " + batchEnd + "/" + keyCount + " processed (" + failedCount + " failed), elapsed " + elapsedSec + "s");
      while (nextProgressAt <= batchEnd) nextProgressAt += PROGRESS_EVERY;
    }
  }

  const successfulKeys = keys.filter((k) => k !== undefined);
  const failurePct = (failedCount / keyCount) * 100;
  if (failurePct > TOLERANCE_PCT) {
    fail("createKeys: " + failedCount + "/" + keyCount + " (" + failurePct.toFixed(2) + "%) keys failed after " + MAX_RETRIES + " retries; exceeds tolerance " + TOLERANCE_PCT + "%");
  }
  if (failedCount > 0) {
    console.warn("createKeys: " + failedCount + "/" + keyCount + " (" + failurePct.toFixed(2) + "%) keys failed but within tolerance " + TOLERANCE_PCT + "%; proceeding with " + successfulKeys.length + " keys");
  }
  return successfulKeys;
};

const generateKeys = (keyCount) => {
  const baseURL = "https://${helm_release.kong.name}-gateway-admin:8444";
  createConsumers(baseURL, APP_COUNT);
  return createKeys(baseURL, keyCount);
};

export { generateKeys };
EOF
  }

  depends_on = [kubernetes_namespace.kong]
}