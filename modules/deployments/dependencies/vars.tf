variable "namespace" {
  type    = string
  default = "dependencies"
}

variable "label" {
  type = string
}

variable "grafana" {
  type = object({
    service = object({
      type = string
    })
  })

  default = {
    service = {
      type = "ClusterIP"
    }
  }
}

variable "open_telemetry" {
  type = object({
    enabled = bool
  })
}

variable "keycloak" {
  type = object({
    enabled = bool
  })
}

variable "scaling_webhook" {
  type = object({
    enabled      = bool
    cluster_type = string
    aws_region   = string
    gcp_region   = string
  })
  
  default = {
    enabled      = false
    cluster_type = "eks"
    aws_region   = "us-west-2"
    gcp_region   = "us-central1-a"
  }
  
  description = "Scaling webhook configuration for dynamic node scaling"
}
