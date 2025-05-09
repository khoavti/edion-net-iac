output "log_group_names" {
  value = [for name, log in aws_cloudwatch_log_group.this : log.name]
}
