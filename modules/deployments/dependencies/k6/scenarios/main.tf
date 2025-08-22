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
    // Dynamically scales stages based on total duration
    executor: 'ramping-arrival-rate',
    startRate: Math.floor(rate * 0.5),
    timeUnit: '1s',
    preAllocatedVUs: virtual_users * 2,
    maxVUs: virtual_users * 5,
    stages: (() => {
      // Calculate phase durations as percentages of total duration
      const totalMinutes = duration;
      const baselinePercent = 0.17;  // ~17% for baseline
      const scaleUpPercent = 0.50;   // ~50% for scale up
      const scaleDownPercent = 0.33; // ~33% for scale down
      
      // Calculate actual durations in minutes
      const baselineDuration = Math.floor(totalMinutes * baselinePercent);
      const scaleUpDuration = Math.floor(totalMinutes * scaleUpPercent);
      const scaleDownDuration = Math.floor(totalMinutes * scaleDownPercent);
      
      // For short tests (< 30 min), use simpler staging
      if (totalMinutes < 30) {
        return [
          { target: rate, duration: Math.floor(totalMinutes * 0.1) + 'm' },
          { target: rate, duration: Math.floor(totalMinutes * 0.2) + 'm' },
          { target: rate * 2.33, duration: Math.floor(totalMinutes * 0.4) + 'm' },
          { target: rate, duration: Math.floor(totalMinutes * 0.3) + 'm' },
        ];
      }
      
      // Calculate step durations for each phase
      const rampUpTime = Math.max(1, Math.floor(baselineDuration * 0.2));
      const baselineHoldTime = baselineDuration - rampUpTime;
      const scaleUpStepTime = Math.floor(scaleUpDuration / 8); // 4 steps up, each with hold
      const scaleDownStepTime = Math.floor(scaleDownDuration / 6); // Fewer steps down
      
      return [
        // Baseline phase
        { target: rate, duration: rampUpTime + 'm' },           // Ramp up to baseline
        { target: rate, duration: baselineHoldTime + 'm' },     // Hold baseline
        
        // Scale up phase - 4 steps
        { target: rate * 1.33, duration: scaleUpStepTime + 'm' },    // Step 1: -> 20k
        { target: rate * 1.33, duration: scaleUpStepTime + 'm' },    // Hold at 20k
        { target: rate * 1.67, duration: scaleUpStepTime + 'm' },    // Step 2: -> 25k
        { target: rate * 1.67, duration: scaleUpStepTime + 'm' },    // Hold at 25k
        { target: rate * 2, duration: scaleUpStepTime + 'm' },       // Step 3: -> 30k
        { target: rate * 2, duration: scaleUpStepTime + 'm' },       // Hold at 30k
        { target: rate * 2.33, duration: scaleUpStepTime + 'm' },    // Step 4: -> 35k
        { target: rate * 2.33, duration: scaleUpStepTime + 'm' },    // Hold at peak
        
        // Scale down phase
        { target: rate * 2, duration: scaleDownStepTime + 'm' },     // Step down: -> 30k
        { target: rate * 1.67, duration: scaleDownStepTime + 'm' },  // Step down: -> 25k
        { target: rate * 1.67, duration: scaleDownStepTime + 'm' },  // Hold at 25k
        { target: rate * 1.33, duration: scaleDownStepTime + 'm' },  // Step down: -> 20k
        { target: rate, duration: scaleDownStepTime + 'm' },         // Step down: -> 15k
        { target: rate, duration: scaleDownStepTime + 'm' },         // Hold at baseline
      ];
    })(),
  },
});

export { getScenarios };
EOF
  }
}
