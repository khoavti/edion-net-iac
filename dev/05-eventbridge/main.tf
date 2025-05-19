provider "aws" {
  region = "ap-northeast-1"  # Tokyo region
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/ecs_lambda_start_stop.py"
  output_path = "${path.module}/lambda/ecs_lambda_start_stop.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "ecs_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow",
      Sid = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "ecs_lambda" {
  function_name = "ECS_Svc_Start_Stop"
  description   = "Lambda to start/stop ECS services"
  filename      = data.archive_file.lambda_zip.output_path
  handler       = "ecs_lambda_start_stop.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.9"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

resource "aws_cloudwatch_event_rule" "stop_app_service" {
  name                = "stop-app-service-schedule"
  schedule_expression = "cron(0 12 * * ? *)" # 21:00 JST = 12:00 UTC
  description         = "Stop app service"
}

resource "aws_cloudwatch_event_rule" "start_app_service" {
  name                = "start-app-service-schedule"
  schedule_expression = "cron(0 0 * * ? *)"  # 09:00 JST = 00:00 UTC
  description         = "Start app service"
}

resource "aws_cloudwatch_event_rule" "stop_manage_service" {
  name                = "stop-manage-service-schedule"
  schedule_expression = "cron(0 12 * * ? *)"
  description         = "Stop manage service"
}

resource "aws_cloudwatch_event_rule" "start_manage_service" {
  name                = "start-manage-service-schedule"
  schedule_expression = "cron(0 0 * * ? *)"
  description         = "Start manage service"
}

resource "aws_cloudwatch_event_target" "stop_app_target" {
  rule = aws_cloudwatch_event_rule.stop_app_service.name
  arn  = aws_lambda_function.ecs_lambda.arn

  input = jsonencode({
    cluster          = ["edion-net-dev-app-cluster01"]
    desired_count_off = 0
  })
}

resource "aws_cloudwatch_event_target" "start_app_target" {
  rule = aws_cloudwatch_event_rule.start_app_service.name
  arn  = aws_lambda_function.ecs_lambda.arn

  input = jsonencode({
    cluster          = ["edion-net-dev-app-cluster01"]
    desired_count_1  = 1
    desired_count_2  = 2
    filter_string    = "test-cc-max"
    desired_count_off = 0
  })
}

resource "aws_cloudwatch_event_target" "stop_manage_target" {
  rule = aws_cloudwatch_event_rule.stop_manage_service.name
  arn  = aws_lambda_function.ecs_lambda.arn

  input = jsonencode({
    cluster          = ["edion-net-dev-manage-cluster01"]
    desired_count_off = 0
  })
}

resource "aws_cloudwatch_event_target" "start_manage_target" {
  rule = aws_cloudwatch_event_rule.start_manage_service.name
  arn  = aws_lambda_function.ecs_lambda.arn

  input = jsonencode({
    cluster          = ["edion-net-dev-manage-cluster01"]
    desired_count_1  = 1
    desired_count_2  = 2
    filter_string    = "test-cc-max"
    desired_count_off = 0
  })
}

resource "aws_lambda_permission" "allow_eventbridge_stop_app" {
  statement_id  = "AllowExecutionFromEventBridgeStopApp"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecs_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_app_service.arn
}

resource "aws_lambda_permission" "allow_eventbridge_start_app" {
  statement_id  = "AllowExecutionFromEventBridgeStartApp"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecs_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_app_service.arn
}

resource "aws_lambda_permission" "allow_eventbridge_stop_manage" {
  statement_id  = "AllowExecutionFromEventBridgeStopManage"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecs_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_manage_service.arn
}

resource "aws_lambda_permission" "allow_eventbridge_start_manage" {
  statement_id  = "AllowExecutionFromEventBridgeStartManage"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecs_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_manage_service.arn
}

