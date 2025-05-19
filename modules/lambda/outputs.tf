output "lambda_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.this.arn
}

output "lambda_invoke_role_arn" {
  description = "IAM Role ARN for EventBridge Scheduler to invoke Lambda"
  value       = aws_iam_role.invoke_role.arn
}
