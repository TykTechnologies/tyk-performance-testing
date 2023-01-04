resource "kubernetes_secret" "tyk-operator-secret" {
  metadata {
    name      = "tyk-operator-conf"
    namespace = var.namespace
  }

  data = {
    TYK_MODE                     = "ce"
    TYK_URL                      = "P4ssw0rd"
    TYK_AUTH                     = "P4ssw0rd"
    TYK_ORG                      = "P4ssw0rd"
    TYK_TLS_INSECURE_SKIP_VERIFY = false
  }

  depends_on = [helm_release.tyk]
}

resource "helm_release" "tyk-operator" {
  name       = "tyk-operator"
  repository = "https://helm.tyk.io/public/helm/charts/"
  chart      = "tyk-operator"

  namespace = var.namespace

  set {
    name  = "nodeSelector.node"
    value = "tyk-resources"
  }

  depends_on = [kubernetes_secret.tyk-operator-secret]
}