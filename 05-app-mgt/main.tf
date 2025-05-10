# File: layers/04-app-web/main.tf

terraform {
  backend "local" {}  # Cấu hình backend local cho layer này
}

module "eventbridge_scheduler" {
  source = "../modules/eventbridge-schedule"

  environment        = var.environment
  aws_region         = var.aws_region
  aws_account_id     = var.aws_account_id
  scheduler_role_arn = var.eventbridge_scheduler_role_arn
  schedules          = var.schedules
}
