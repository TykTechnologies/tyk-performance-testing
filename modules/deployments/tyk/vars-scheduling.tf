variable "node_selector_strategy" {
  description = "How to place pods on nodepools: 'strict' uses hard nodeSelector, 'prefer' uses soft nodeAffinity, 'none' disables node selection"
  type        = string
  default     = "none"
  validation {
    condition     = contains(["strict", "prefer", "none"], var.node_selector_strategy)
    error_message = "node_selector_strategy must be 'strict', 'prefer', or 'none'."
  }
}

variable "enable_tolerations" {
  description = "Enable tolerations for nodes that are tainted (e.g., dedicated workloads)."
  type        = bool
  default     = false
}

variable "node_taint_key" {
  description = "Taint key to tolerate if enable_tolerations is true (e.g., 'dedicated' or 'node.kubernetes.io/dedicated')."
  type        = string
  default     = "dedicated"
}

variable "node_taint_value" {
  description = "Taint value to tolerate (e.g., 'tyk' or 'tyk-resources')."
  type        = string
  default     = "tyk"
}

variable "node_taint_operator" {
  description = "Toleration operator (Equal or Exists)."
  type        = string
  default     = "Equal"
}

variable "node_taint_effect" {
  description = "Toleration effect (NoSchedule, PreferNoSchedule, or NoExecute)."
  type        = string
  default     = "NoSchedule"
}