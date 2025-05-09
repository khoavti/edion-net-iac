resource "aws_cloudwatch_log_group" "this" {
  for_each = {
    for log in var.log_groups : log.name => log
  }

  name              = each.value.name
  retention_in_days = each.value.retention_in_days
  log_group_class   = each.value.class
}
