resource "kubernetes_config_map" "scenarios-configmap" {
  metadata {
    name      = "scenarios-configmap"
    namespace = var.namespace
  }

  data = {
    "scenarios.js" = <<EOF
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
  "autoscaling-gradual": {
    // Single ramping scenario that covers baseline, scale-up, and scale-down phases
    executor: 'ramping-arrival-rate',
    startRate: Math.floor(rate * 0.5),
    timeUnit: '1s',
    preAllocatedVUs: virtual_users * 2,
    maxVUs: virtual_users * 5,
    stages: [
      // Baseline phase (0-5m)
      { target: rate, duration: '1m' },           // Ramp up to baseline (15k)
      { target: rate, duration: '4m' },           // Hold baseline for 4 minutes
      
      // Scale up phase (5m-20m)
      { target: rate * 1.33, duration: '2m' },    // Step 1: 15k -> 20k
      { target: rate * 1.33, duration: '2m' },    // Hold at 20k
      { target: rate * 1.67, duration: '2m' },    // Step 2: 20k -> 25k
      { target: rate * 1.67, duration: '2m' },    // Hold at 25k
      { target: rate * 2, duration: '2m' },       // Step 3: 25k -> 30k
      { target: rate * 2, duration: '1m' },       // Hold at 30k
      { target: Math.round(rate * 2.33), duration: '2m' },    // Step 4: 30k -> 35k
      { target: Math.round(rate * 2.33), duration: '2m' },    // Hold at 35k
      
      // Scale down phase (20m-30m)
      { target: rate * 2, duration: '1m' },       // Step down: 35k -> 30k
      { target: rate * 1.67, duration: '2m' },    // Step down: 30k -> 25k
      { target: rate * 1.67, duration: '1m' },    // Hold at 25k
      { target: rate * 1.33, duration: '2m' },    // Step down: 25k -> 20k
      { target: rate, duration: '2m' },           // Step down: 20k -> 15k
      { target: rate, duration: '2m' },           // Hold at baseline (15k)
    ],
  },
});

export { getScenarios };
EOF
  }
}
