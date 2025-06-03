output "role_arn" {
  value       = aws_iam_role.this.arn
  description = "ARN of the IAM Role"
}

output "role_name" {
  value       = aws_iam_role.this.name
  description = "Name of the IAM Role"
}
