variable "role_name" {
  description = "Name of the IAM Role"
  type        = string
}

variable "trusted_service" {
  description = "Trusted AWS service (e.g., ecs-tasks.amazonaws.com)"
  type        = string
}

variable "policy_statements" {
  description = "List of inline IAM policy statements"
  type = list(object({
    Effect   = string
    Action   = any
    Resource = any
  }))
  default = []
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach"
  type        = list(string)
  default     = []
}
