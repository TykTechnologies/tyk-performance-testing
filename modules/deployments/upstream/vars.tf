variable "namespace" {
  type    = string
  default = "upstream"
}

variable "label" {
  type = string
}

variable "enable_timestamp" {
  type = bool
}

variable "enable_httpbin" {
  type = bool
}

variable "enable_users_rest" {
  type = bool
}

variable "enable_posts_rest" {
  type = bool
}

variable "enable_comments_rest" {
  type = bool
}

variable "enable_users_graphql" {
  type = bool
}
variable "enable_posts_graphql" {
  type = bool
}
variable "enable_comments_graphql" {
  type = bool
}
variable "enable_notifications_graphql" {
  type = bool
}

variable "enable_users_subgraph" {
  type = bool
}
variable "enable_posts_subgraph" {
  type = bool
}
variable "enable_comments_subgraph" {
  type = bool
}
variable "enable_notifications_subgraph" {
  type = bool
}
