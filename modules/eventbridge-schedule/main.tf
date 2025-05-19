resource "aws_scheduler_schedule" "this" {
  for_each = { for sched in var.schedules : sched.schedule_name => sched }

  name        = each.value.schedule_name
  description = each.value.description
  group_name  = "default"
  state       = each.value.state
  schedule_expression = each.value.schedule_expression
  schedule_expression_timezone = "Asia/Tokyo"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:automation-definition/AWS-UpdateECSServiceDesiredCount"
    role_arn = var.scheduler_role_arn

    input = jsonencode({
      Service       = each.value.target_service_name
      Cluster       = each.value.target_cluster_name
      DesiredCount  = tostring(each.value.target_task_count)
    })
  }
}
