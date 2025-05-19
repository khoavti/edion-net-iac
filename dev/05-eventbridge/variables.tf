variable "environment" {
  type    = string
  default = "dev"
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "aws_account_id" {
  type    = string
  default = "555516925462"
}

variable "schedules" {
  type = list(object({
    schedule_name       = string
    description         = string
    schedule_expression = string
    timezone            = string
    state               = string
    target_cluster_name = string
    target_service_name = string
    target_task_count   = number
  }))

  default = [
    {
      schedule_name       = "dev-stop-app-service-schedule"
      description         = "Stop Registration ECS service nightly at 21:00 JST for dev."
      schedule_expression = "cron(0 21 * * ? *)"
      timezone            = "Asia/Tokyo"
      state               = "ENABLED"
      target_cluster_name = "edion-net-dev-app-cluster01"
      target_service_name = "edion-net-app-registration-dev-service"
      target_task_count   = 0
    },
    {
      schedule_name       = "dev-stop-manage-service-schedule"
      description         = "Stop Admin ECS service nightly at 21:00 JST for dev."
      schedule_expression = "cron(0 21 * * ? *)"
      timezone            = "Asia/Tokyo"
      state               = "ENABLED"
      target_cluster_name = "edion-net-dev-app-mgt-cluster01"
      target_service_name = "edion-net-app-manage-dev-service"
      target_task_count   = 0
    },
    {
      schedule_name       = "dev-start-app-service-schedule"
      description         = "Start Registration ECS service daily at 09:00 JST for dev."
      schedule_expression = "cron(0 9 * * ? *)"
      timezone            = "Asia/Tokyo"
      state               = "ENABLED"
      target_cluster_name = "edion-net-dev-app-cluster01"
      target_service_name = "edion-net-app-registration-dev-service"
      target_task_count   = 1
    },
    {
      schedule_name       = "dev-start-manage-service-schedule"
      description         = "Start Admin ECS service daily at 09:00 JST for dev."
      schedule_expression = "cron(0 9 * * ? *)"
      timezone            = "Asia/Tokyo"
      state               = "ENABLED"
      target_cluster_name = "edion-net-dev-app-mgt-cluster01"
      target_service_name = "edion-net-app-manage-dev-service"
      target_task_count   = 1
    }
  ]
}
