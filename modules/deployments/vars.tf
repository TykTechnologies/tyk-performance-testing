variable "labels" {
  type = object({
    dependencies       = string
    tyk                = string
    tyk-upstream       = string
    tyk-tests          = string
    tyk-resources      = string
    kong               = string
    kong-upstream      = string
    kong-tests         = string
    kong-resources     = string
    gravitee           = string
    gravitee-upstream  = string
    gravitee-tests     = string
    gravitee-resources = string
    traefik            = string
    traefik-upstream   = string
    traefik-tests      = string
    traefik-resources  = string
    upstream           = string
    upstream-tests     = string
  })
}
