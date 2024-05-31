module "tests" {
  source    = "../tests"
  namespace = var.namespace

  depends_on = [kubernetes_config_map.auth-configmap]
}

resource "kubernetes_config_map" "auth-configmap" {
  metadata {
    name      = "auth-configmap"
    namespace = var.namespace
  }

  data = {
    "auth.js" = <<EOF
const generateKeys = (apiName, keyCount) => {
  const baseURL = "http://dashboard-svc-tyk-tyk-dashboard:3000/";

  return {};
};

export { generateKeys };
EOF
  }
}