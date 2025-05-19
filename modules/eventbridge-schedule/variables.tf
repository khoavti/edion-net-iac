variable "aws_region" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "scheduler_role_arn" {
  type = string
}

variable "schedules" {
  description = "List of schedule configurations"
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
}
