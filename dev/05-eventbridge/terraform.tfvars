role_name       = "ecs_lambda_role"
trusted_service = "lambda.amazonaws.com"
policy_arns = [
  "arn:aws:iam::aws:policy/AmazonECS_FullAccess",
  "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
]

function_name = "ECS_Svc_Start_Stop"
description   = "Lambda to start/stop ECS services"
handler       = "ecs_lambda_start_stop.lambda_handler"
runtime       = "python3.9"
role_arn      = "arn:aws:iam::555516925462:role/ecs_lambda_role"

lambda_function_name = "ECS_Svc_Start_Stop"
lambda_function_arn  = "arn:aws:lambda:ap-northeast-1:555516925462:function:ECS_Svc_Start_Stop"

