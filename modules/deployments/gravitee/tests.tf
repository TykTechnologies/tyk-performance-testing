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

  depends_on = [kubernetes_namespace.gravitee]
}

module "scenarios" {
  source    = "../dependencies/k6/scenarios"
  namespace = var.namespace

  depends_on = [kubernetes_namespace.gravitee]
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

const BATCH_SIZE = 50;
const MAX_RETRIES = 3;
const TOLERANCE_PCT = 1;
const PROGRESS_EVERY = 1000;

const getAPIIds = (baseURL, apiCount) => {
  const res = http.get(baseURL + '/apis/?page=1&size=' + apiCount, { responseType: 'text' });
  check(res, {
    'apis get call status is 200': (r) => r.status === 200,
  }) || fail('Failed to get APIs');

  const apiIds = [];
  const data = res.json().data;

  for (let i = 0; i < apiCount; i++) {
    let api = data.find((api) => api.name === "api-" + i);
    check(api, {
      ['api "api-' + i + '" exists']: (a) => a,
    }) || fail('API "api-' + i + '" not found');

    apiIds.push(api.id);
  }

  return apiIds;
};

const getPlanIds = (baseURL, apiIds, planCount) => {
  const planIds = [];
  const apiCount = apiIds.length;

  for (let i = 0; i < planCount; i++) {
    let  res = http.get(baseURL + '/apis/' + apiIds[i % apiCount] + '/plans', { responseType: 'text' });
    check(res, {
      'plans get call status is 200': (r) => r.status === 200,
    }) || fail('Failed to get plans');

    let plan = res.json().data.find((plan) => plan.name === "API_KEY");
    check(plan, {
      'plan API_KEY exists': (p) => p,
    }) || fail('Plan "API_KEY" not found');

    planIds.push(plan.id)
  }

  return planIds;
};

const params = {
  responseType: 'text',
  headers: {
    'Authorization': "Basic YWRtaW46YWRtaW4=",
    'Content-Type': 'application/json',
  },
};

// Run an http.batch with per-request retries and a soft failure tolerance.
// requestBuilder(i) -> [method, url, body, params]
// successCheck(response) -> boolean
// successExtractor(response) -> the value to store at index i
// label is just for log lines.
const batchedCreate = (label, count, requestBuilder, successCheck, successExtractor) => {
  const out = new Array(count);
  let failedCount = 0;
  const startMs = Date.now();
  let nextProgressAt = PROGRESS_EVERY;

  for (let batchStart = 0; batchStart < count; batchStart += BATCH_SIZE) {
    const batchEnd = Math.min(batchStart + BATCH_SIZE, count);
    let requests = [];
    let indices = [];
    for (let i = batchStart; i < batchEnd; i++) {
      requests.push(requestBuilder(i));
      indices.push(i);
    }

    for (let attempt = 0; attempt <= MAX_RETRIES; attempt++) {
      const responses = http.batch(requests);
      const retryRequests = [];
      const retryIndices = [];
      for (let r = 0; r < responses.length; r++) {
        if (successCheck(responses[r])) {
          out[indices[r]] = successExtractor(responses[r]);
        } else if (attempt < MAX_RETRIES) {
          retryRequests.push(requests[r]);
          retryIndices.push(indices[r]);
        } else {
          failedCount++;
          console.warn(label + ": #" + indices[r] + " failed after " + MAX_RETRIES + " retries (status=" + responses[r].status + ", body=" + (responses[r].body || "").slice(0, 200) + ")");
        }
      }
      if (retryRequests.length === 0) break;
      sleep(0.1 * Math.pow(2, attempt));
      requests = retryRequests;
      indices = retryIndices;
    }

    if (batchEnd >= nextProgressAt || batchEnd === count) {
      const elapsedSec = ((Date.now() - startMs) / 1000).toFixed(1);
      console.log(label + ": " + batchEnd + "/" + count + " processed (" + failedCount + " failed), elapsed " + elapsedSec + "s");
      while (nextProgressAt <= batchEnd) nextProgressAt += PROGRESS_EVERY;
    }
  }

  const failurePct = (failedCount / count) * 100;
  if (failurePct > TOLERANCE_PCT) {
    fail(label + ": " + failedCount + "/" + count + " (" + failurePct.toFixed(2) + "%) failed after " + MAX_RETRIES + " retries; exceeds tolerance " + TOLERANCE_PCT + "%");
  }
  if (failedCount > 0) {
    console.warn(label + ": " + failedCount + "/" + count + " (" + failurePct.toFixed(2) + "%) failed but within tolerance " + TOLERANCE_PCT + "%");
  }
  return out;
};

const createApplications = (baseURL, keyCount) => {
  const ids = batchedCreate(
    "createApplications",
    keyCount,
    (i) => {
      const name = 'app-' + i;
      const payload = JSON.stringify({ name: name, description: name, settings: { app: {} } });
      return ['POST', baseURL + '/applications', payload, params];
    },
    (r) => r.status === 201,
    (r) => r.json().id
  );
  return ids.filter((id) => id !== undefined);
};

const createSubscriptions = (baseURL, planIds, applicationIds) => {
  const planCount = planIds.length;
  const keys = batchedCreate(
    "createSubscriptions",
    applicationIds.length,
    (i) => {
      const payload = JSON.stringify({ application: applicationIds[i], plan: planIds[i % planCount] });
      return ['POST', baseURL + '/subscriptions', payload, params];
    },
    (r) => r.status === 200,
    (r) => r.json().keys[0].key
  );
  return keys.filter((k) => k !== undefined);
};

const generateKeys = (keyCount) => {
  const baseURL = "http://${helm_release.gravitee.name}-apim-api:83/portal/environments/DEFAULT";
  const apiIds = getAPIIds(baseURL, ${var.service.route_count});
  const planIds = getPlanIds(baseURL, apiIds, ${var.service.app_count});
  const applicationIds = createApplications(baseURL, keyCount);

  return createSubscriptions(baseURL, planIds, applicationIds);
};

export { generateKeys };
EOF
  }

  depends_on = [kubernetes_namespace.gravitee]
}