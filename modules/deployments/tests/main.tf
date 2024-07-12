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
  "externally-controlled": {
    executor: 'externally-controlled',
    duration: duration + "m",
    vus: 10,
    maxVUs: virtual_users,
  },
});

const addTestInfoMetrics = ({ duration, rate, virtual_users }, key_count) => {
  analyticsGauge.add(1, {
    isEnabled: ${var.analytics.database.enabled} || ${var.analytics.prometheus.enabled} ? "Enabled" : "Disabled",
    database: ${var.analytics.database.enabled} ? "Enabled" : "Disabled",
    prometheus: ${var.analytics.prometheus.enabled} ? "Enabled" : "Disabled",
  });

  authGauge.add(key_count, {
    isEnabled: ${var.auth.enabled} ? "Enabled" : "Disabled",
  });

  quotaGauge.add(1, {
    isEnabled: ${var.quota.enabled} ? "Enabled" : "Disabled",
    rate: ${var.quota.rate},
    per: ${var.quota.per},
  });

  rateLimitGauge.add(1, {
    isEnabled: ${var.rate_limit.enabled} ? "Enabled" : "Disabled",
    rate: ${var.rate_limit.rate},
    per: ${var.rate_limit.per},
  });

  openTelemetryGauge.add(${var.open_telemetry.sampling_ratio}, {
    isEnabled: ${var.open_telemetry.enabled} ? "Enabled" : "Disabled",
    sampling_ratio: ${var.open_telemetry.sampling_ratio},
  });

  durationGauge.add(duration);
  rateGauge.add(rate);
  virtualUsersGauge.add(virtual_users);
};

const getAuth = () => ${var.auth.enabled};

export { getAuth, getScenarios, addTestInfoMetrics };

EOF
  }
}
