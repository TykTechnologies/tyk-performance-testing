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
