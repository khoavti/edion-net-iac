resource "aws_ecs_task_definition" "taskdef" {
  for_each = var.taskdefs

  family                   = each.value.family
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  network_mode             = each.value.network_mode
  execution_role_arn       = each.value.execution_role_arn
  task_role_arn            = lookup(each.value, "task_role_arn", null)

  container_definitions    = each.value.container_definitions

  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
