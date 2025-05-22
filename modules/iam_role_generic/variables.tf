variable "role_name" {
  description = "Name of the IAM Role"
  type        = string
}

variable "trusted_service" {
  description = "Trusted AWS service (e.g., scheduler.amazonaws.com)"
  type        = string
}

variable "policy_statements" {
  description = "IAM policy statements list"
  type = list(object({
    Effect   = string
    Action   = any
    Resource = any
  }))
}
