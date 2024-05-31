resource "kubernetes_config_map" "tests-configmap" {
  metadata {
    name      = "tests-configmap"
    namespace = var.namespace
  }

  data = {
    "tests.js" = <<EOF
import http from 'k6/http';
import { Gauge } from 'k6/metrics';

const analyticsGauge     = new Gauge('deployment_config_analytics');
const authGauge          = new Gauge('deployment_config_auth');
const quotaGauge         = new Gauge('deployment_config_quota');
const rateLimitGauge     = new Gauge('deployment_config_rate_limit');
const openTelemetryGauge = new Gauge('deployment_config_open_telemetry');

const durationGauge     = new Gauge('test_config_duration');
const rateGauge         = new Gauge('test_config_rate');
const virtualUsersGauge = new Gauge('test_config_virtual_users');

const getScenarios = ({ ramping_steps, duration, rate, virtual_users }) => ({
  "constant-vus": {
    executor: 'constant-vus',
    vus: virtual_users,
    duration: duration + "m",
  },
  "ramping-vus": {
    executor: 'ramping-vus',
    stages: [...Array(ramping_steps)].map((_, i) =>
      ({
        target: virtual_users * ((i + 1) / ramping_steps),
        duration: (duration * (1 / ramping_steps)) + "m",
      })
    ),
  },
  "constant-arrival-rate": {
    executor: 'constant-arrival-rate',
    duration: duration + "m",
    rate: rate,
    timeUnit: '1s',
    preAllocatedVUs: virtual_users,
  },
  "ramping-arrival-rate": {
    executor: 'ramping-arrival-rate',
    startRate: 1000,
    timeUnit: '1s',
    preAllocatedVUs: virtual_users,
    stages: [ ...([...Array(ramping_steps)].map((_, i) =>
      ({
        target: rate * ((i + 1) / ramping_steps),
        duration: '6s',
      })
    )), {
      target: rate,
      duration: (duration - ramping_steps * 0.1) + "m",
    }],
  },
});

const addTestInfoMetrics = ({ analytics, auth, quota, rate_limit, duration, rate, virtual_users }, key_count) => {
  analyticsGauge.add(1, {
    enabled: analytics.database.enabled || analytics.prometheus.enabled ? "Enabled" : "Disabled",
    database: analytics.database.enabled ? "Enabled" : "Disabled",
    prometheus: analytics.prometheus.enabled ? "Enabled" : "Disabled",
  });

  authGauge.add(key_count, {
    enabled: auth.enabled ? "Enabled" : "Disabled",
  });

  quotaGauge.add(quota.rate, {
    enabled: quota.enabled ? "Enabled" : "Disabled",
    per: quota.per,
  });

  rateLimitGauge.add(rate_limit.rate, {
    enabled: rate_limit.enabled ? "Enabled" : "Disabled",
    per: rate_limit.per,
  });

  openTelemetryGauge.add(open_telemetry.sampling_ratio, {
    enabled: open_telemetry.enabled ? "Enabled" : "Disabled",
  });

  durationGauge.add(duration);
  rateGauge.add(rate);
  virtualUsersGauge.add(virtual_users);
};

export { getScenarios, addTestInfoMetrics };

EOF
  }
}
