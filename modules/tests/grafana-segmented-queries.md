# Grafana Queries for Segmented Tests

When tests run in 60-minute segments to avoid k6 Prometheus timeout issues, use these queries to aggregate metrics across all segments.

## RPS (Requests Per Second) - Aggregated Across Segments

```promql
# Aggregate RPS across all segments for a test
sum by(testid) (
  rate(k6_http_reqs_total{testid=~"$testid", segment=~".*", group!="::setup"}[30s])
)

# Or if you want to see segments separately
sum by(testid, segment) (
  rate(k6_http_reqs_total{testid=~"$testid", group!="::setup"}[30s])
)
```

## Latency Metrics - Aggregated Across Segments

```promql
# P75 Latency (average across all segments)
avg by(testid) (
  k6_http_req_duration_p75{testid=~"$testid", segment=~".*", group!="::setup"}
)

# P95 Latency
avg by(testid) (
  k6_http_req_duration_p95{testid=~"$testid", segment=~".*", group!="::setup"}
)

# P99 Latency
avg by(testid) (
  k6_http_req_duration_p99{testid=~"$testid", segment=~".*", group!="::setup"}
)
```

## Error Rate - Aggregated Across Segments

```promql
# Error rate across all segments
sum by(testid) (
  rate(k6_http_req_failed_total{testid=~"$testid", segment=~".*"}[30s])
) / 
sum by(testid) (
  rate(k6_http_reqs_total{testid=~"$testid", segment=~".*"}[30s])
) * 100
```

## Virtual Users - Show Maximum Across Segments

```promql
# Maximum VUs across all segments
max by(testid) (
  k6_vus{testid=~"$testid", segment=~".*"}
)
```

## Segment Progress Visualization

```promql
# Show which segment is currently running
max by(testid, segment) (
  k6_vus{testid=~"$testid"} > 0
)
```

## Dashboard Variables

Add these variables to your Grafana dashboard:

1. **testid**: Query: `label_values(k6_http_reqs_total, testid)`
2. **segment**: Query: `label_values(k6_http_reqs_total{testid="$testid"}, segment)`
3. **show_segments**: Custom variable with values: `aggregated`, `separate`

## Panel Configuration Examples

### RPS Panel
- **Title**: "Requests Per Second (All Segments)"
- **Query**: Use the aggregated RPS query above
- **Legend**: `{{testid}} - Total RPS`
- **Unit**: `reqps` (requests per second)

### Latency Panel
- **Title**: "Response Time Percentiles (All Segments)"
- **Queries**: Add P75, P95, P99 queries
- **Legend**: `P75`, `P95`, `P99`
- **Unit**: `ms` (milliseconds)

### Segment Status Panel
- **Title**: "Test Segment Status"
- **Query**: Segment progress visualization query
- **Visualization**: State timeline or Status history
- **Value mappings**: 
  - 0 = "Not Started"
  - 1 = "Running"

## Notes

1. **Segment Tags**: Each segment is tagged with `segment=1`, `segment=2`, etc.
2. **Time Range**: Set dashboard time range to cover all segments (e.g., 5+ hours for a 300-minute test)
3. **Refresh Rate**: Set to 5-10 seconds during active tests
4. **Data Gaps**: Small gaps between segments are normal during cleanup/restart

## Example Test Execution

For a 300-minute test:
- Segment 1: Minutes 0-60 (segment=1)
- Segment 2: Minutes 60-120 (segment=2)
- Segment 3: Minutes 120-180 (segment=3)
- Segment 4: Minutes 180-240 (segment=4)
- Segment 5: Minutes 240-300 (segment=5)

Each segment's metrics will be available for its full 60-minute duration without the k6 Prometheus timeout issues.