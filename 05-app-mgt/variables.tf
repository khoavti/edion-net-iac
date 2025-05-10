# File: layers/04-app-web/variables.tf

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)."
  type        = string
}

variable "aws_region" {
  description = "AWS region for the layer's resources."
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID for the layer's resources."
  type        = string
}

variable "app_ecs_cluster_name" {
  description = "Name of the application ECS cluster created in a lower layer."
  type        = string
}

variable "mgt_ecs_cluster_name" {
  description = "Name of the management application ECS cluster created in a lower layer."
  type        = string
}

variable "eventbridge_scheduler_role_arn" {
  description = "ARN of the IAM role that EventBridge Scheduler will assume to manage ECS services."
  type        = string
}

variable "schedules" {
  description = "Configuration for EventBridge Schedules to be created in this layer."
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
