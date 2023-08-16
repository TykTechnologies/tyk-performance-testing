resource "helm_release" "jaeger-operator" {
  name       = "jaeger-operator"
  repository = "https://jaegertracing.github.io/helm-charts"
  chart      = "jaeger-operator"
  version    = "v2.46.2"

  namespace = "dependencies"

  set {
    name  = "nodeSelector.node"
    value = var.label
  }

  depends_on = [helm_release.cert-manager]
}

resource "kubectl_manifest" "jaeger" {
  yaml_body = <<YAML
apiVersion: jaegertracing.io/v1
kind: Jaeger
metadata:
  name: jaeger
  namespace: dependencies
spec:
  allInOne:
    affinity:
      nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          nodeSelectorTerms:
          - matchExpressions:
            - key: node
              operator: In
              values:
              - dependencies
YAML
  depends_on = [helm_release.jaeger-operator]
}
