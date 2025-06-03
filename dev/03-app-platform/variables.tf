variable "clusters" {
  description = "Map of ECS clusters configurations"
  type = map(object({
    name = string
    container_insights = string
    log_name = string
  }))
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-1"
}