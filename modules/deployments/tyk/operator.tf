resource "kubernetes_secret" "tyk-operator-secret" {
  metadata {
    name      = "tyk-operator-conf"
    namespace = var.namespace
  }

  data = {
    TYK_MODE                     = "ce"
    TYK_URL                      = "http://gateway-svc-${helm_release.tyk.name}.${helm_release.tyk.namespace}.svc:8080"
    TYK_AUTH                     = "CHANGEME"
    TYK_ORG                      = "tyk"
    TYK_TLS_INSECURE_SKIP_VERIFY = false
  }

  depends_on = [helm_release.tyk]
}

resource "helm_release" "tyk-operator" {
  name       = "tyk-operator"
  repository = "https://helm.tyk.io/public/helm/charts/"
  chart      = "tyk-operator"

  namespace        = var.namespace
  create_namespace = true
  atomic           = true

  set {
    name  = "nodeSelector.node"
    value = var.resources-label
  }

  set {
    name  = "podAnnotations.otelEnabled"
    type  = "string"
    value = var.oTel.enabled
  }

  set {
    name  = "podAnnotations.otelSamplingRatio"
    type  = "string"
    value = var.oTel.sampling_ratio
  }

  set {
    name  = "podAnnotations.analtyics"
    type  = "string"
    value = var.analytics
  }

  depends_on = [kubernetes_secret.tyk-operator-secret]
}