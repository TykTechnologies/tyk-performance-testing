module "upstream" {
  source    = "../dependencies/upstream"
  namespace = var.namespace
  label     = var.label
}

module "scenarios" {
  source    = "../dependencies/k6/scenarios"
  namespace = var.namespace
}

resource "kubernetes_config_map" "tests-configmap" {
  metadata {
    name      = "tests-configmap"
    namespace = var.namespace
  }

  data = {
    "tests.js" = <<EOF
const addTestInfoMetrics = () => {};
const getAuth = () => false;
const getAuthType = () => "";
const generateJWTKeys = () => [];

export { getAuth, getAuthType, generateJWTKeys, addTestInfoMetrics };

EOF
  }
}

resource "kubernetes_config_map" "auth-configmap" {
  metadata {
    name      = "auth-configmap"
    namespace = var.namespace
  }

  data = {
    "auth.js" = <<EOF
const generateKeys = (keyCount) => {};
export { generateKeys };
EOF
  }
}
