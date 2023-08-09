variable "namespace" {
  type    = string
  default = "upstream"
}

variable "label" {
  type = string
}

variable "enable_timestamp" {
  type    = bool
  default = true
}

variable "enable_httpbin" {
  type    = bool
  default = true
}

variable "enable_users_rest" {
  type    = bool
  default = true
}
variable "enable_posts_rest" {
  type    = bool
  default = true
}
variable "enable_comments_rest" {
  type    = bool
  default = true
}

variable "enable_users_graphql" {
  type    = bool
  default = true
}
variable "enable_posts_graphql" {
  type    = bool
  default = true
}
variable "enable_comments_graphql" {
  type    = bool
  default = true
}
variable "enable_notifications_graphql" {
  type    = bool
  default = true
}

variable "enable_users_subgraph" {
  type    = bool
  default = true
}
variable "enable_posts_subgraph" {
  type    = bool
  default = true
}
variable "enable_comments_subgraph" {
  type    = bool
  default = true
}
variable "enable_notifications_subgraph" {
  type    = bool
  default = true
}
