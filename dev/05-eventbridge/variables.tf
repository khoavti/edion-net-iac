variable "role_name" {
  description = "Tên IAM Role"
  type        = string
}

variable "trusted_service" {
  description = "Dịch vụ được phép assume role"
  type        = string
}

variable "policy_arns" {
  description = "Danh sách policy ARN được attach vào role"
  type        = list(string)
}


variable "function_name" {
  type        = string
  description = "Tên của Lambda function"
}

variable "description" {
  type        = string
  description = "Mô tả chức năng của Lambda"
}

variable "handler" {
  type        = string
  description = "Handler cho Lambda"
}

variable "runtime" {
  type        = string
  description = "Runtime của Lambda function"
}

variable "source_file" {
  type        = string
  description = "Đường dẫn file nguồn (Python script)"
  default     = "lambda/ecs_lambda_start_stop.py"
}

variable "role_arn" {
  type        = string
  description = "IAM Role ARN dùng cho Lambda"
}


variable "lambda_function_name" {
  description = "Tên Lambda function để gắn vào EventBridge"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN của Lambda function"
  type        = string
}



