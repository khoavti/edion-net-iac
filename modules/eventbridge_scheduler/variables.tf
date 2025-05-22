variable "schedule_name" {
  description = "Name of the EventBridge schedule"
  type        = string
}

variable "description" {
  description = "Schedule description"
  type        = string
}

variable "schedule_group" {
  description = "Name of the schedule group"
  type        = string
  default     = "default"
}

variable "cron_expression" {
  description = "Cron expression for the schedule"
  type        = string
}

variable "timezone" {
  description = "Timezone for the schedule"
  type        = string
  default     = "Asia/Tokyo"
}

variable "role_arn" {
  description = "ARN of the IAM role used by EventBridge"
  type        = string
}

variable "target_cluster_arn" {
  description = "ARN of the ECS Cluster"
  type        = string
}

variable "target_service_name" {
  description = "Name of the ECS Service"
  type        = string
}

variable "target_task_count" {
  description = "Number of tasks to run"
  type        = number
}
