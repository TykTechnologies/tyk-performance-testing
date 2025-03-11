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
import { check, fail } from 'k6';

const params = {
  responseType: 'text',
  headers: {
    'Content-Type': 'application/json',
  },
};

const createConsumers = (baseURL, appCount) => {
  for (let i = 0; i < appCount; i++) {
    const payload = JSON.stringify({
      username: 'app-' + i
    });

    const res = http.post(baseURL + '/consumers/', payload, params);
    check(res, {
      ['consumer "app-' + i + '" creation status is 201/409']: (r) => r.status === 201 || r.status === 409,
    }) || fail('Failed to create consumer "app-' + i + '"');
  }
};

const createKeys = (baseURL, keyCount) => {
  const keys = [];
  for (let i = 0; i < keyCount; i++) {
    const res = http.post(baseURL + '/consumers/app-' + i % ${var.service.app_count} + '/key-auth/', JSON.stringify({}), params);
    check(res, {
      ['key for consumer "app-' + i % ${var.service.app_count} + '" creation status is 201']: (r) => r.status === 201,
    }) || fail('Failed to create key for consumer "app-' + i % ${var.service.app_count} + '"');

    keys.push(res.json().key);
  }

  return keys;
};

const generateKeys = (keyCount) => {
  const baseURL = "https://${helm_release.kong.name}-gateway-admin:8444";
  createConsumers(baseURL, ${var.service.app_count});

  return createKeys(baseURL, keyCount);
};

export { generateKeys };
EOF
  }

  depends_on = [kubernetes_namespace.kong]
}