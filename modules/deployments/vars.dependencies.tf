variable "dependencies" {
  type = object({
    grafana = object({
      service = object({
        type = string
      })
    })
    scaling_webhook = object({
      enabled      = bool
      cluster_type = string
      aws_region   = string
    })
  })
}

variable "upstream" {
  type = object({
    enabled = bool
  })
}