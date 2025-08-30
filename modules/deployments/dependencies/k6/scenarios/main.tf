resource "kubernetes_config_map" "scenarios-configmap" {
  metadata {
    name      = "scenarios-configmap"
    namespace = var.namespace
  }

  data = {
    "scenarios.js" = <<EOF
// Helper utilities: robust minutes parsing + resolution
const __parseMinutes = (val) => {
  if (val === undefined || val === null) return NaN;
  const n = Number(String(val).replace(/[^0-9.]/g, ''));
  return Number.isFinite(n) ? n : NaN;
};

// Prefer templated param (stable for initializer), then ENV (runner/initializer), else fail
const __resolveTotalMinutes = (paramDuration) => {
  const fromParam = __parseMinutes(paramDuration);
  const fromEnv = (typeof __ENV !== 'undefined') ? __parseMinutes(__ENV.DURATION_MINUTES) : NaN;
  const total = (Number.isFinite(fromParam) && fromParam > 0) ? fromParam
    : (Number.isFinite(fromEnv) && fromEnv > 0) ? fromEnv : NaN;
  if (!Number.isFinite(total) || total <= 0) {
    throw new Error('[autoscaling-gradual] Unable to resolve totalMinutes; param='
      + String(paramDuration) + ' env='
      + (typeof __ENV !== 'undefined' ? String(__ENV.DURATION_MINUTES) : '(undefined)'));
  }
  return total;
};
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
    gracefulStop: '2m',  // Allow time for clean shutdown and metric flush
    // Ensure long tests aren't cut by executor default maxDuration (1h)
    maxDuration: (duration + 5) + "m",
  },
  "ramping-arrival-rate": {
    executor: 'ramping-arrival-rate',
    startRate: 1000,
    timeUnit: '1s',
    preAllocatedVUs: virtual_users,
    // Ensure long tests aren't cut by executor default maxDuration (1h)
    maxDuration: (duration + 5) + "m",
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
    gracefulStop: '2m',
    // Cap overall time above planned stages to avoid the 1h default limit
    maxDuration: ((__resolveTotalMinutes(duration) + 5) + 'm'),
    stages: (() => {
      // Calculate phase durations as percentages of total duration
      // Debug: log all available information
      // Note: initializer must see env *or* we use templated param; otherwise we fail fast
      const hasEnv = (typeof __ENV !== 'undefined') && typeof __ENV.DURATION_MINUTES !== 'undefined';
      console.log('[autoscaling-gradual] __ENV.DURATION_MINUTES:', hasEnv ? __ENV.DURATION_MINUTES : '(undefined)');
      console.log('[autoscaling-gradual] duration parameter (if templated):', (typeof duration !== 'undefined') ? duration : '(undefined)');
      console.log('[autoscaling-gradual] __ENV keys:', Object.keys(__ENV || {}));

      // Resolve totalMinutes robustly and reject unknown values (no silent 60m fallback)
      const totalMinutes = __resolveTotalMinutes(duration);
      console.log('[autoscaling-gradual] FINAL totalMinutes=' + totalMinutes);
      const baselinePercent = 0.17;  // ~17% for baseline
      const scaleUpPercent = 0.50;   // ~50% for scale up
      const scaleDownPercent = 0.33; // ~33% for scale down
      
      // Calculate actual durations in minutes
      const baselineDuration = Math.floor(totalMinutes * baselinePercent);
      const scaleUpDuration = Math.floor(totalMinutes * scaleUpPercent);
      const scaleDownDuration = totalMinutes - baselineDuration - scaleUpDuration; // Use remainder for scale down
      
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
      const baselineHoldTime = Math.max(1, baselineDuration - rampUpTime);
      const scaleUpStepTime = Math.max(1, Math.floor(scaleUpDuration / 8)); // 4 steps up, each with hold
      const scaleUpRemainder = scaleUpDuration - (scaleUpStepTime * 8);
      const scaleDownStepTime = Math.max(1, Math.floor(scaleDownDuration / 6)); // Fewer steps down
      const scaleDownRemainder = scaleDownDuration - (scaleDownStepTime * 6);
      
      const s = [
        // Baseline phase
        { target: Math.round(rate), duration: rampUpTime + 'm' },           // Ramp up to baseline
        { target: Math.round(rate), duration: baselineHoldTime + 'm' },     // Hold baseline
        
        // Scale up phase - 4 steps
        { target: Math.round(rate * 1.33), duration: scaleUpStepTime + 'm' },    // Step 1: -> 20k
        { target: Math.round(rate * 1.33), duration: scaleUpStepTime + 'm' },    // Hold at 20k
        { target: Math.round(rate * 1.67), duration: scaleUpStepTime + 'm' },    // Step 2: -> 25k
        { target: Math.round(rate * 1.67), duration: scaleUpStepTime + 'm' },    // Hold at 25k
        { target: Math.round(rate * 2.00), duration: scaleUpStepTime + 'm' },    // Step 3: -> 30k
        { target: Math.round(rate * 2.00), duration: scaleUpStepTime + 'm' },    // Hold at 30k
        { target: Math.round(rate * 2.33), duration: scaleUpStepTime + 'm' },    // Step 4: -> 35k
        { target: Math.round(rate * 2.33), duration: (scaleUpStepTime + scaleUpRemainder) + 'm' },    // Hold at peak (include remainder)
        
        // Scale down phase
        { target: Math.round(rate * 2.00), duration: scaleDownStepTime + 'm' },  // Step down: -> 30k
        { target: Math.round(rate * 1.67), duration: scaleDownStepTime + 'm' },  // Step down: -> 25k
        { target: Math.round(rate * 1.67), duration: scaleDownStepTime + 'm' },  // Hold at 25k
        { target: Math.round(rate * 1.33), duration: scaleDownStepTime + 'm' },  // Step down: -> 20k
        { target: Math.round(rate), duration: scaleDownStepTime + 'm' },          // Step down: -> 15k
        { target: Math.round(rate), duration: (scaleDownStepTime + scaleDownRemainder) + 'm' },  // Hold at baseline (include remainder)
      ];
      
      // Sanity: confirm stage sum equals totalMinutes
      const sumMins = s.reduce((acc, st) => {
        const m = (typeof st.duration === 'string' && st.duration.endsWith('m'))
          ? parseInt(st.duration, 10) : 0;
        return acc + (Number.isFinite(m) ? m : 0);
      }, 0);
      console.log('[autoscaling-gradual] sanity: sum(stages)=' + sumMins + 'm; expected=' + totalMinutes + 'm');
      if (sumMins !== totalMinutes) {
        console.log('[autoscaling-gradual][WARN] stage sum (' + sumMins + 'm) != totalMinutes (' + totalMinutes + 'm)');
      }
      return s;
    })(),
  },
});

export { getScenarios };
EOF
  }
}
