data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = var.source_file
  output_path = var.output_path
}

resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  description      = var.description
  filename         = data.archive_file.lambda_zip.output_path
  handler          = var.handler
  role             = var.role_arn
  runtime          = var.runtime
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

output "lambda_name" {
  value = aws_lambda_function.this.function_name
}

output "lambda_arn" {
  value = aws_lambda_function.this.arn
}
