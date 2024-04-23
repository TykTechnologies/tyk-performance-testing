variable "kubernetes" {
  type = object({
    config = object({
      path    = string
      context = string
    })
  })

  default = {
    config = {
      path    = "~/.kube/config"
      context = "minikube"
    }
  }
}