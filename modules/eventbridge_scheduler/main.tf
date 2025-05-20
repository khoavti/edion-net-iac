resource "aws_cloudwatch_event_rule" "this" {
  for_each = var.schedules
  name                = each.key
  schedule_expression = each.value.expression
  description         = each.value.description
}
resource "aws_cloudwatch_event_target" "this" {
  for_each = var.schedules
  rule      = each.key
  target_id = each.key
  arn       = var.lambda_arn
  input     = jsonencode(each.value.input)
  depends_on = [aws_cloudwatch_event_rule.this]
}
resource "aws_lambda_permission" "this" {
  for_each = aws_cloudwatch_event_rule.this
  statement_id  = "AllowExecutionFrom_${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = each.value.arn
}
