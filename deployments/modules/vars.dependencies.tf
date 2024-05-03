variable "dependencies" {
  type = object({
    grafana = object({
      service = object({
        type = string
      })
    })
  })
}