variable "dependencies" {
  type = object({
    grafana = object({
      service = object({
        type = string
      })
    })
  })
}

variable "upstream" {
  type = object({
    enabled = bool
  })
}