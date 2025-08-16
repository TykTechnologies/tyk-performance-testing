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
    // Multi-phase autoscaling test for HPA and cluster autoscaler
    baseline_phase: {
      executor: 'ramping-arrival-rate',
      startRate: Math.floor(rate * 0.5),
      timeUnit: '1s',
      preAllocatedVUs: virtual_users,
      maxVUs: virtual_users * 4,
      stages: [
        { target: rate, duration: '1m' },           // Ramp up to baseline
        { target: rate, duration: '4m' },           // Hold baseline for 4 minutes
      ],
      exec: 'default',
      startTime: '0s',
      tags: { phase: 'baseline' },
    },
    scale_up_phase: {
      executor: 'ramping-arrival-rate',
      startRate: rate,
      timeUnit: '1s',
      preAllocatedVUs: virtual_users * 2,
      maxVUs: virtual_users * 5,
      stages: [
        { target: rate * 1.25, duration: '2m' },    // Step 1: 20k -> 25k
        { target: rate * 1.25, duration: '2m' },    // Hold at 25k
        { target: rate * 1.5, duration: '2m' },     // Step 2: 25k -> 30k
        { target: rate * 1.5, duration: '2m' },     // Hold at 30k
        { target: rate * 1.75, duration: '2m' },    // Step 3: 30k -> 35k
        { target: rate * 1.75, duration: '1m' },    // Hold at 35k
        { target: rate * 2, duration: '2m' },       // Step 4: 35k -> 40k
        { target: rate * 2, duration: '2m' },       // Hold at 40k
      ],
      exec: 'default',
      startTime: '5m',
      tags: { phase: 'scale_up' },
    },
    scale_down_phase: {
      executor: 'ramping-arrival-rate',
      startRate: rate * 2,
      timeUnit: '1s',
      preAllocatedVUs: virtual_users * 2,
      maxVUs: virtual_users * 4,
      stages: [
        { target: rate * 1.75, duration: '1m' },    // Step down: 40k -> 35k
        { target: rate * 1.5, duration: '2m' },     // Step down: 35k -> 30k
        { target: rate * 1.5, duration: '1m' },     // Hold at 30k
        { target: rate * 1.25, duration: '2m' },    // Step down: 30k -> 25k
        { target: rate, duration: '2m' },           // Step down: 25k -> 20k
        { target: rate, duration: '2m' },           // Hold at baseline
      ],
      exec: 'default',
      startTime: '20m',
      tags: { phase: 'scale_down' },
    }
  },
});

export { getScenarios };
EOF
  }
}
