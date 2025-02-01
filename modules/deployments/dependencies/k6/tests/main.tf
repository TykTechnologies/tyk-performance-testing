resource "kubernetes_config_map" "tests-configmap" {
  metadata {
    name      = "tests-configmap"
    namespace = var.namespace
  }

  data = {
    "tests.js" = <<EOF
import http from 'k6/http';
import { check, fail } from 'k6';
import { Gauge } from 'k6/metrics';
import crypto from 'k6/crypto';
import encoding from 'k6/encoding';

const analyticsGauge       = new Gauge('deployment_config_analytics');
const authGauge            = new Gauge('deployment_config_auth');
const quotaGauge           = new Gauge('deployment_config_quota');
const rateLimitGauge       = new Gauge('deployment_config_rate_limit');
const openTelemetryGauge   = new Gauge('deployment_config_open_telemetry');
const headerInjectionGauge = new Gauge('deployment_config_header_injection');

const durationGauge     = new Gauge('test_config_duration');
const rateGauge         = new Gauge('test_config_rate');
const virtualUsersGauge = new Gauge('test_config_virtual_users');

const addTestInfoMetrics = ({ duration, rate, virtual_users }, key_count) => {
  const analytics = [ ${var.analytics.database.enabled} ? "Database" : "", ${var.analytics.prometheus.enabled} ? "Prometheus" : "",  ].filter(item => item !== "")
  analyticsGauge.add(1, {
    state: analytics.length > 0 ? analytics.join(", ") : "Off",
  });

  authGauge.add(1, {
    state: ${var.auth.enabled} ? "${var.auth.type} / " + key_count : "Off",
  });

  quotaGauge.add(1, {
    state: ${var.quota.enabled} ? "${var.quota.rate} / ${var.quota.per}" : "Off",
  });

  rateLimitGauge.add(1, {
    state: ${var.rate_limit.enabled} ? "${var.rate_limit.rate} / ${var.rate_limit.per}" : "Off",
  });

  openTelemetryGauge.add(1, {
    state: ${var.open_telemetry.enabled} ? "${var.open_telemetry.sampling_ratio}" : "Off",
  });

  const header_injection = [ ${var.header_injection.req.enabled} ? "Req" : "", ${var.header_injection.res.enabled} ? "Res" : "",  ].filter(item => item !== "")
  headerInjectionGauge.add(1, {
    state: header_injection.length > 0 ? header_injection.join(" / ") : "Off",
  });

  durationGauge.add(duration);
  rateGauge.add(rate);
  virtualUsersGauge.add(virtual_users);
};

const getAuth = () => ${var.auth.enabled};
const getAuthType = () => "${var.auth.type}";

const generateJWTKeys = (keyCount) => {
  const keys = [];
  const params = {
    responseType: 'text',
  };

  for (let i = 0; i < keyCount; i++) {
    let payload = {
      client_id: 'keycloak-jwt',
      grant_type: 'password',
      client_secret: 'wcl7lBoslXBMAHKinMwa1bbEuBQSCUtI',
      scope: 'openid',
      username: 'user' + i % 100 + '@test.com',
      password: 'topsecretpassword',
    };

    const res = http.post("http://keycloak-service.dependencies.svc:8080/realms/jwt/protocol/openid-connect/token", payload, params);
    check(res, {
      ['key creation call status is 200']: (r) => r.status === 200,
    }) || fail('Failed to create key');
    keys.push(res.json().access_token);
  }
  return keys;
};

const sign = (data, secret) => {
  const hasher = crypto.createHMAC('sha256', secret);
  hasher.update(data);
  return hasher.digest("base64rawurl");
}

const encode = (payload, secret) => {
  const header = encoding.b64encode(
    JSON.stringify({ typ: "JWT", alg: "HS256" }),
    "rawurl"
  );
  payload = encoding.b64encode(JSON.stringify(payload), "rawurl");
  const sig = sign(header + "." + payload, secret);
  return [header, payload, sig].join(".");
}

const generateHMACKeys = (keyCount) => {
    const keys = [];
    const secret = "topsecretpassword";

    for (let i = 0; i < keyCount; i++) {
        const now = Math.floor(Date.now() / 1000);

        keys.push(encode({
            sub: 'user' + i % 100 + '@test.com',
            iat: now,
            exp: now + 86400, // 24 hours from now
            iss: "k6",
            jti: 'jwt-' + i + '-' + now // Unique JWT ID
        }, secret));
    }
    return keys;
};

export { getAuth, getAuthType, generateJWTKeys, generateHMACKeys, addTestInfoMetrics };

EOF
  }
}
