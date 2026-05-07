resource "helm_release" "opentelemetry-collector" {
  name       = "opentelemetry-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = "0.62.0"

  namespace = var.namespace
  atomic    = true

  set {
    name  = "nodeSelector.node"
    value = var.label
  }

  set {
    name  = "mode"
    value = "deployment"
  }

  set {
    name  = "config.receivers.otlp.protocols.http.endpoint"
    value = "0.0.0.0:4318"
  }

  set {
    name  = "config.receivers.otlp.protocols.grpc.endpoint"
    value = "0.0.0.0:4317"
  }

  set {
    name  = "config.exporters.jaeger.endpoint"
    value = "jaeger-collector.dependencies.svc:14250"
  }

  set {
    name  = "config.exporters.jaeger.tls.insecure"
    value = "true"
  }

  set {
    name  = "config.extensions.pprof.endpoint"
    value = ":1888"
  }

  set {
    name  = "config.extensions.zpages.endpoint"
    value = ":55679"
  }

  set {
    name  = "config.service.extensions[0]"
    value = "pprof"
  }

  set {
    name  = "config.service.extensions[1]"
    value = "zpages"
  }

  set {
    name  = "config.service.extensions[2]"
    value = "health_check"
  }

  set {
    name  = "config.service.pipelines.traces.receivers[0]"
    value = "otlp"
  }

  set {
    name  = "config.service.pipelines.traces.processors[0]"
    value = "batch"
  }

  set {
    name  = "config.service.pipelines.traces.exporters[0]"
    value = "jaeger"
  }

  set {
    name  = "config.exporters.logging.verbosity"
    value = "basic"
  }

  # Forward OTel metrics (Tyk runtime/Go GC stats and request counters) into the
  # same Prometheus that k6 already writes to, so test traffic and gateway
  # health metrics share one Grafana datasource. Memory-leak regressions like
  # PR 8180 - which look like flat throughput plus rising RSS / heap_objects /
  # goroutines - become a single dashboard panel away.
  set {
    name  = "config.exporters.prometheusremotewrite.endpoint"
    value = "http://prometheus-server.dependencies.svc:80/api/v1/write"
  }

  set {
    name  = "config.exporters.prometheusremotewrite.tls.insecure"
    value = "true"
  }

  set {
    name  = "config.service.pipelines.metrics.receivers[0]"
    value = "otlp"
  }

  set {
    name  = "config.service.pipelines.metrics.processors[0]"
    value = "batch"
  }

  set {
    name  = "config.service.pipelines.metrics.exporters[0]"
    value = "prometheusremotewrite"
  }

  count      = (var.open_telemetry.enabled || var.open_telemetry.metrics_enabled) ? 1 : 0
  depends_on = [kubernetes_namespace.dependencies]
}
