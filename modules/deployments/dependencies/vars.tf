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

variable "dockerhub_username" {
  type        = string
  description = "Docker Hub username for authenticated image pulls"
  default     = ""
}

variable "dockerhub_password" {
  type        = string
  description = "Docker Hub password for authenticated image pulls"
  sensitive   = true
  default     = ""
}
