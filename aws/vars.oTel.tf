variable "oTel" {
  type = object({
    enabled        = bool
    sampling_ratio = string
  })
  default = {
    enabled        = true
    sampling_ratio = "0.5"
  }
}