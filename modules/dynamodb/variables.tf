variable "dynamodb_config" {
  description = "Configuration for DynamoDB table"
  type = object({
    table_name   = string
    hash_key     = string
    billing_mode = string
  })
}
