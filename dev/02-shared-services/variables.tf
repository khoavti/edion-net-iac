variable "secure_buckets" {
  description = "Map of secure S3 buckets with enhanced security configurations"
  type = map(object({
    bucket_name = string
    region = string
    object_lock_enabled = bool
    server_side_encryption = object({
      algorithm = string
      bucket_key_enabled = bool
    })
    versioning_enabled = bool
  }))
}


variable "dynamodb_config" {
  description = "Configuration for DynamoDB table"
  type = object({
    table_name   = string
    hash_key     = string
    billing_mode = string
  })
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-1"
}

variable "log_groups" {
  type = list(object({
    name              = string
    retention_in_days = number
    class             = string
  }))
}