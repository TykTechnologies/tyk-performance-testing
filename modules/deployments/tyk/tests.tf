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

const createKey = (baseURL, policyId) => {
  const payload = JSON.stringify({
    "allowance": -1,
    "rate": -1,
    "per": -1,
    "throttle_interval": -1,
    "quota_max": -1,
    "apply_policies": [ policyId ]
  });

  const res = http.post(baseURL + '/api/keys', payload, params);
  check(res, {
    ['key creation call status is 200']: (r) => r.status === 200,
  }) || fail('Failed to create key');

  return res.json().key_id;
};

const generateKeys = (keyCount) => {
  const keys = [];
  const baseURL = "http://dashboard-svc-tyk-tyk-dashboard:3000";

  for (let i = 0; i < keyCount; i++) {
    keys.push(createKey(baseURL, base64UrlEncode(`${var.namespace}/api-policy-$${i % ${var.service.app_count}}`)));
  }

  return keys;
};

export { generateKeys };
EOF
  }
}