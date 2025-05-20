variable "name" {
  description = "Name of the IAM role"
  type        = string
}

variable "assume_role_policy" {
  description = "The assume role policy document in JSON"
  type        = string
}

variable "policy_arns" {
  description = "List of IAM policy ARNs to attach"
  type        = list(string)
}
