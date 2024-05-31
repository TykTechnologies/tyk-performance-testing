module "tests" {
  source    = "../tests"
  namespace = var.namespace
  auth      = var.auth

  depends_on = [kubernetes_config_map.auth-configmap]
}

resource "kubernetes_config_map" "auth-configmap" {
  metadata {
    name      = "auth-configmap"
    namespace = var.namespace
  }

  data = {
    "auth.js" = <<EOF
import http from 'k6/http';
import { check, fail } from 'k6';

const getAPIId = (baseURL, apiName) => {
  const res = http.get(baseURL + '/apis/', { responseType: 'text' });
  check(res, {
    'apis get call status is 200': (r) => r.status === 200,
  }) || fail('Failed to get APIs');

  const api = res.json().data.find((api) => api.name === apiName);
  check(api, {
    ['api "' + apiName + '" exists']: (a) => a,
  }) || fail('API "' + apiName + '" not found');

  return api.id;
};

const getPlanId = (baseURL, apiId) => {
  const res = http.get(baseURL + '/apis/' + apiId + '/plans', { responseType: 'text' });
  check(res, {
    'plans get call status is 200': (r) => r.status === 200,
  }) || fail('Failed to get plans');

  const plan = res.json().data.find((plan) => plan.name === "API_KEY");
  check(plan, {
    'plan API_KEY exists': (p) => p,
  }) || fail('Plan "API_KEY" not found');

  return plan.id;
};

const params = {
  responseType: 'text',
  headers: {
    'Authorization': "Basic YWRtaW46YWRtaW4=",
    'Content-Type': 'application/json',
  },
};

const createApplications = (baseURL, keyCount) => {
  const applicationIds = [];
  for (let i = 0; i < keyCount; i++) {
    const name = 'app' + i;
    const payload = JSON.stringify({
      name: name,
      description: name,
      settings: { app: {} }
    });

    const res = http.post(baseURL + '/applications', payload, params);
    check(res, {
      ['application "' + name + '" creation status is 201']: (r) => r.status === 201,
    }) || fail('Failed to create application "' + name + '"');

    applicationIds.push(res.json().id);
  }
  return applicationIds;
};

const createSubscriptions = (baseURL, planId, applicationIds) => {
  const keys = [];
  for (let i = 0; i < applicationIds.length; i++) {
    const payload = JSON.stringify({
      application: applicationIds[i],
      plan: planId
    });

    const res = http.post(baseURL + '/subscriptions', payload, params);
    check(res, {
      ['subscription for application "' + applicationIds[i] + '" creation status is 200']: (r) => r.status === 200,
    }) || fail('Failed to create subscription for application "' + applicationIds[i] + '"');

    keys.push(res.json().keys[0].key);
  }

  return keys;
};

const generateKeys = (apiName, keyCount) => {
  const baseURL = "http://${helm_release.gravitee.name}-apim-api:83/portal/environments/DEFAULT";
  const apiId = getAPIId(baseURL, apiName);
  const planId = getPlanId(baseURL, apiId);
  const applicationIds = createApplications(baseURL, keyCount);

  return createSubscriptions(baseURL, planId, applicationIds);
};

export { generateKeys };
EOF
  }
}