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

resource "kubernetes_config_map" "auth-configmap" {
  metadata {
    name      = "auth-configmap"
    namespace = var.namespace
  }

  data = {
    "auth.js" = <<EOF
import http from 'k6/http';
import { check, fail } from 'k6';

const params = {
  responseType: 'text',
  headers: {
    'Content-Type': 'application/json',
  },
};

const createConsumers = (baseURL, keyCount) => {
  for (let i = 0; i < keyCount; i++) {
    const payload = JSON.stringify({
      username: 'app' + i
    });

    const res = http.post(baseURL + '/consumers/', payload, params);
    check(res, {
      ['consumer "app' + i + '" creation status is 201/409']: (r) => r.status === 201 || r.status === 409,
    }) || fail('Failed to create consumer "app' + i + '"');
  }
};

const createKeys = (baseURL, keyCount) => {
  const keys = [];
  for (let i = 0; i < keyCount; i++) {
    const res = http.post(baseURL + '/consumers/app' + i + '/key-auth/', JSON.stringify({}), params);
    check(res, {
      ['key for consumer "app' + i + '" creation status is 201']: (r) => r.status === 201,
    }) || fail('Failed to create key for consumer "app' + i + '"');

    keys.push(res.json().key);
  }

  return keys;
};

const generateKeys = (keyCount) => {
  const baseURL = "https://${helm_release.kong.name}-gateway-admin:8444";
  createConsumers(baseURL, keyCount);

  return createKeys(baseURL, keyCount);
};

export { generateKeys };
EOF
  }
}