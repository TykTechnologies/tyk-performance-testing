variable "dockerhub_username" {
  type        = string
  description = "Docker Hub username for authenticated image pulls - bypasses rate limits"
  default     = ""
}

variable "dockerhub_password" {
  type        = string
  description = "Docker Hub password for authenticated image pulls"
  sensitive   = true
  default     = ""
}
