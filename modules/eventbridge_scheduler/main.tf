resource "aws_scheduler_schedule" "this" {
  name       = var.schedule_name
  group_name = var.schedule_group
  state      = "ENABLED"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = var.cron_expression
  schedule_expression_timezone = var.timezone

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ecs:updateService"
    role_arn = var.role_arn

    input = jsonencode({
      Cluster      = var.target_cluster_arn
      Service      = var.target_service_name
      DesiredCount = var.target_task_count
    })
  }

  description = var.description
}
