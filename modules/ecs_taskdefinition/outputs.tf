output "task_definition_arns" {
  value = { for k, v in aws_ecs_task_definition.taskdef : k => v.arn }
}
