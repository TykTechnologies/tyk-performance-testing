module "tests" {
  source         = "../tests"
  namespace      = var.namespace
  analytics      = var.analytics
  auth           = var.auth
  quota          = var.quota
  rate_limit     = var.rate_limit
  open_telemetry = var.open_telemetry

  depends_on = [kubernetes_config_map.auth-configmap]
}

data "kubernetes_secret" "tyk-operator-conf" {
  metadata {
    name      = "tyk-operator-conf"
    namespace = var.namespace
  }

  depends_on = [helm_release.tyk]
}

resource "kubernetes_config_map" "auth-configmap" {
  metadata {
    name      = "auth-configmap"
    namespace = var.namespace
  }

  depends_on = [data.kubernetes_secret.tyk-operator-conf]
  data = {
    "auth.js" = <<EOF
import http from 'k6/http';
import { check, fail } from 'k6';
import { b64encode } from 'k6/encoding';

const base64UrlEncode = (str) => {
  return b64encode(str).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

const params = {
  responseType: 'text',
  headers: {
    'Authorization': "${data.kubernetes_secret.tyk-operator-conf.data["TYK_AUTH"]}",
    'Content-Type': 'application/json',
  },
};

const createKeys = (baseURL, policyId, keyCount) => {
  const keys = [];
  const payload = JSON.stringify({
    "allowance": -1,
    "rate": -1,
    "per": -1,
    "throttle_interval": -1,
    "quota_max": -1,
    "apply_policies": [ policyId ]
  });

  for (let i = 0; i < keyCount; i++) {
    const res = http.post(baseURL + '/api/keys', payload, params);
    check(res, {
      ['key creation call status is 200']: (r) => r.status === 200,
    }) || fail('Failed to create key');
    keys.push(res.json().key_id);
  }
  return keys;
};

const generateKeys = (apiName, keyCount) => {
  const baseURL = "http://dashboard-svc-tyk-tyk-dashboard:3000";
  const policyId = base64UrlEncode("${var.namespace}/" + apiName + "-policy");

  return createKeys(baseURL, policyId, keyCount);
};

export { generateKeys };
EOF
  }
}