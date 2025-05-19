resource "aws_dynamodb_table" "app_sessions" {
  name           = var.dynamodb_config.table_name
  billing_mode   = var.dynamodb_config.billing_mode

  hash_key       = var.dynamodb_config.hash_key
  
  attribute {
    name = var.dynamodb_config.hash_key
    type = "S"
  }
}
