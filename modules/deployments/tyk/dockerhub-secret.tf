# Docker Hub image pull secret for authenticated pulls
# Bypasses rate limits: 200 pulls/6hrs (authenticated) vs 100 pulls/6hrs (anonymous)

resource "kubernetes_secret" "dockerhub" {
  count = var.dockerhub_username != "" && var.dockerhub_password != "" ? 1 : 0

  metadata {
    name      = "dockerhub-secret"
    namespace = var.namespace
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://index.docker.io/v1/" = {
          username = var.dockerhub_username
          password = var.dockerhub_password
          auth     = base64encode("${var.dockerhub_username}:${var.dockerhub_password}")
        }
      }
    })
  }

  depends_on = [kubernetes_namespace.tyk]
}
