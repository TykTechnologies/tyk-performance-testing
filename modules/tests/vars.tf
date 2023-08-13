variable "namespace" {
  type = string
}

variable "service_name" {
  type = string
}

variable "service_url" {
  type = string
}

variable "parallelism" {
  type    = number
  default = 1
  # Currently not possible to set the value of parallelism to more than one
  # because of implementation of the separate flag limitation.
}
