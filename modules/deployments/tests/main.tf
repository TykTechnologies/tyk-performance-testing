resource "kubernetes_config_map" "tests-configmap" {
  metadata {
    name      = "tests-configmap"
    namespace = var.namespace
  }

  data = {
    "tests.js" = <<EOF
import http from 'k6/http';
import { Gauge } from 'k6/metrics';

const duration      = new Gauge('test_config_duration');
const rate          = new Gauge('test_config_rate');
const virtual_users = new Gauge('test_config_virtual_users');

const getScenarios = (ramping_steps, duration, rate, virtual_users) => ({
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

const get = (config, url) => {
  duration.add(config.duration);
  rate.add(config.rate);
  virtual_users.add(config.virtual_users);
  http.get(url);
};

const post = (config, url, body) => {
  duration.add(config.duration);
  rate.add(config.rate);
  virtual_users.add(config.virtual_users);
  http.post(url, body);
};

export { getScenarios, get, post };

EOF
  }
}