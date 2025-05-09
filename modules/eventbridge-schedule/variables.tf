# File: modules/eventbridge-schedule/variables.tf

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod). Used for naming."
  type        = string
}

variable "aws_region" {
  description = "AWS region where schedules and target resources reside."
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID where resources reside."
  type        = string
}

variable "schedules" {
  description = "A list of schedule configurations."
  type = list(object({
    schedule_name       = string
    description         = string
    schedule_expression = string
    timezone            = string
    state               = string
    target_type         = string
    target_cluster_name = string
    target_service_name = string
    target_task_count   = number
    task_definition_arn = string
  }))
  default = []
}

variable "scheduler_role_arn" {
  description = "ARN of the IAM role EventBridge Scheduler will assume to perform UpdateService actions on ECS."
  type        = string
}
