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
const executorGauge     = new Gauge('test_config_executor');
const fortioOptsGauge   = new Gauge('tests_fortio_options');

const routeCountGauge = new Gauge('service_route_count');
const appCountGauge   = new Gauge('service_app_count');
const hostCountGauge  = new Gauge('service_host_count');

const addTestInfoMetrics = ({ duration, rate, virtual_users, fortio_options, executor }, key_count) => {
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

  const otelFeatures = [
    ${var.open_telemetry.enabled} ? "Tracing(${var.open_telemetry.sampling_ratio})" : "",
    ${var.open_telemetry.metrics_enabled} ? "Metrics" : "",
    ${var.open_telemetry.runtime_metrics} ? "Runtime" : "",
  ].filter(item => item !== "");
  openTelemetryGauge.add(1, {
    state: otelFeatures.length > 0 ? otelFeatures.join(", ") : "Off",
  });

  const header_injection = [ ${var.header_injection.req.enabled} ? "Req" : "", ${var.header_injection.res.enabled} ? "Res" : "",  ].filter(item => item !== "")
  headerInjectionGauge.add(1, {
    state: header_injection.length > 0 ? header_injection.join(" / ") : "Off",
  });

  durationGauge.add(duration);
  rateGauge.add(rate);
  virtualUsersGauge.add(virtual_users);
  executorGauge.add(1, {
    state: executor || "unknown",
  });
  fortioOptsGauge.add(1, {
    state: fortio_options ? fortio_options.split("&").join(", ") : "None",
  });

  routeCountGauge.add(${var.service.route_count});
  appCountGauge.add(${var.service.app_count});
  hostCountGauge.add(${var.service.host_count});
};

const getAuth = () => ${var.auth.enabled};
const getAuthType = () => "${var.auth.type}";

const getRouteCount = () => ${var.service.route_count};
const getHostCount = () => ${var.service.host_count};

const generateJWTRSAKeys = (keyCount) => {
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

// JWT header is constant - precompute once at module init so the per-request
// signRollingJWT() call doesn't repeat the same JSON.stringify + b64encode work
// at 25k rps. Saves a few microseconds per request, which adds up.
const JWT_HEADER_B64 = encoding.b64encode(
  JSON.stringify({ typ: "JWT", alg: "HS256" }),
  "rawurl"
);

const encode = (payload, secret) => {
  const payloadB64 = encoding.b64encode(JSON.stringify(payload), "rawurl");
  const sig = sign(JWT_HEADER_B64 + "." + payloadB64, secret);
  return JWT_HEADER_B64 + "." + payloadB64 + "." + sig;
}

const JWT_HMAC_SECRET = "topsecretpassword";

const generateJWTHMACKeys = (keyCount) => {
    const keys = [];

    for (let i = 0; i < keyCount; i++) {
        const now = Math.floor(Date.now() / 1000);

        // sub must be unique per key for high-cardinality scenarios (e.g. driving
        // distinct DRL buckets in Tyk to repro PR 8180). Tyk's JWT middleware uses
        // jwt_identity_base_field=sub as the session identity, so a unique sub
        // creates a unique session and therefore a unique rate-limit bucket.
        keys.push(encode({
            sub: 'user' + i + '@test.com',
            iat: now,
            exp: now + 86400, // 24 hours from now
            iss: "k6",
            jti: 'jwt-' + i + '-' + now // Unique JWT ID
        }, JWT_HMAC_SECRET));
    }
    return keys;
};

// Sign a brand-new HMAC JWT with a unique sub per call. Designed to be invoked
// from the per-request hot path when tests_auth_key_rolling is true, so the
// gateway sees an unbounded stream of distinct session identities. Combined
// with rate-limit middleware enabled, this is the cleanest signal for memory
// leaks in the DRL bucket store: with the bug, gateway memory grows linearly
// forever; without it, expired buckets get evicted and memory plateaus.
// HMAC-SHA256 in goja is on the order of tens of microseconds per call; not
// negligible at 15k rps but well below the gateway's per-request budget.
const signRollingJWT = () => {
  const now = Math.floor(Date.now() / 1000);
  const sub = "roll-" + __VU + "-" + __ITER + "-" + Math.floor(Math.random() * 1e9);
  return encode({
    sub: sub,
    iat: now,
    exp: now + 86400,
    iss: "k6",
    jti: sub,
  }, JWT_HMAC_SECRET);
};

export { getAuth, getAuthType, getRouteCount, getHostCount, generateJWTRSAKeys, generateJWTHMACKeys, signRollingJWT, addTestInfoMetrics };

EOF
  }
}
