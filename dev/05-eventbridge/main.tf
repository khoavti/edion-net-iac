provider "aws" {
  region = "ap-northeast-1"  # Tokyo region
}

module "ecs_lambda_role" {
  source = "../../modules/iam_role_generic"

  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = var.trusted_service
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  policy_arns = var.policy_arns
}


module "ecs_lambda" {
  source          = "../../modules/lambda_function"
  function_name   = var.function_name
  description     = var.description
  handler         = var.handler
  runtime         = var.runtime
  source_file     = var.source_file
  role_arn        = var.role_arn
  output_path     = "${path.module}/lambda/ecs_lambda_start_stop.zip"
}

module "ecs_scheduler" {
  source      = "../../modules/eventbridge_scheduler"
  lambda_name = var.lambda_function_name
  lambda_arn  = var.lambda_function_arn

  schedules = {
    "stop-app-service-schedule" = {
      description = "Stop app service"
      expression  = "cron(0 12 * * ? *)"
      input = {
        cluster           = "edion-net-dev-app-cluster01"
        desired_count_off = 0
        desired_count_1   = 0
        desired_count_2   = 0
        filter_string     = ""
      }
    },
    "start-app-service-schedule" = {
      description = "Start app service"
      expression  = "cron(0 0 * * ? *)"
      input = {
        cluster           = "edion-net-dev-app-cluster01"
        desired_count_off = 0
        desired_count_1   = 1
        desired_count_2   = 2
        filter_string     = "test-cc-max"
      }
    },
    "stop-manage-service-schedule" = {
      description = "Stop manage service"
      expression  = "cron(0 12 * * ? *)"
      input = {
        cluster           = "edion-net-dev-manage-cluster01"
        desired_count_off = 0
        desired_count_1   = 0
        desired_count_2   = 0
        filter_string     = ""
      }
    },
    "start-manage-service-schedule" = {
      description = "Start manage service"
      expression  = "cron(0 0 * * ? *)"
      input = {
        cluster           = "edion-net-dev-manage-cluster01"
        desired_count_off = 0
        desired_count_1   = 1
        desired_count_2   = 2
        filter_string     = "test-cc-max"
      }
    }
  }
}

