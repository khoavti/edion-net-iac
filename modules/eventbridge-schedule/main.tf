
resource "aws_scheduler_schedule" "this" {
  for_each = { 
    for schedule in var.schedules : schedule.schedule_name => schedule
  }

  name         = each.value.schedule_name 
  description  = each.value.description   
  group_name   = "default" # Default group or use a specific group variable if needed
  state        = each.value.state # state (ENABLED/DISABLED)

  flexible_time_window {
    mode = "OFF" 
  }

  schedule_expression = each.value.schedule_expression
  schedule_expression_timezone = "Asia/Tokyo"

  target {

    arn      = "arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:service/${each.value.target_cluster_name}/${each.value.target_service_name}"
    role_arn = var.scheduler_role_arn 

    dynamic "ecs_parameters" {
      for_each = each.value.target_type == "ECS" ? [1] : [] 
      content {
         task_count = each.value.target_task_count
         task_definition_arn = each.value.task_definition_arn
      }
    }

    retry_policy {} # Default

  }
}