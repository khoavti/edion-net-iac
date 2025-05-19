environment          = "dev"
aws_region           = "ap-northeast-1"
aws_account_id       = "555516925462"

schedules = [
  {
    schedule_name       = "dev-stop-app-service-schedule"
    description         = "Stop Registration ECS service nightly at 21:00 JST for dev."
    schedule_expression = "cron(0 21 * * ? *)"
    timezone            = "Asia/Tokyo"
    state               = "ENABLED"
    target_type         = "ECS"
    target_cluster_name = "edion-net-dev-app-cluster01"
    target_service_name = "edion-net-app-registration-dev-service"
    target_task_count   = 0
    task_definition_arn = "arn:aws:ecs:ap-northeast-1:555516925462:task-definition/registration-task:1"
  },
  {
    schedule_name       = "dev-stop-manage-service-schedule"
    description         = "Stop Admin ECS service nightly at 21:00 JST for dev."
    schedule_expression = "cron(0 21 * * ? *)"
    timezone            = "Asia/Tokyo"
    state               = "ENABLED"
    target_type         = "ECS"
    target_cluster_name = "edion-net-dev-app-mgt-cluster01"
    target_service_name = "edion-net-app-manage-dev-service"
    target_task_count   = 0
    task_definition_arn = "arn:aws:ecs:ap-northeast-1:555516925462:task-definition/manage-task:1"
  },
  {
    schedule_name       = "dev-start-app-service-schedule"
    description         = "Start Registration ECS service daily at 09:00 JST for dev."
    schedule_expression = "cron(0 9 * * ? *)"
    timezone            = "Asia/Tokyo"
    state               = "ENABLED"
    target_type         = "ECS"
    target_cluster_name = "edion-net-dev-app-cluster01"
    target_service_name = "edion-net-app-registration-dev-service"
    target_task_count   = 1
    task_definition_arn = "arn:aws:ecs:ap-northeast-1:555516925462:task-definition/registration-task:1"
  },
  {
    schedule_name       = "dev-start-manage-service-schedule"
    description         = "Start Admin ECS service daily at 09:00 JST for dev."
    schedule_expression = "cron(0 9 * * ? *)"
    timezone            = "Asia/Tokyo"
    state               = "ENABLED"
    target_type         = "ECS"
    target_cluster_name = "edion-net-dev-app-mgt-cluster01"
    target_service_name = "edion-net-app-manage-dev-service"
    target_task_count   = 1
    task_definition_arn = "arn:aws:ecs:ap-northeast-1:555516925462:task-definition/manage-task:1"
  }
]
