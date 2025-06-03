module "iam_role_scheduler" {
  source           = "../../modules/iam_role_generic"
  role_name        = "edion-net-ecs-scheduler-role"
  trusted_service  = "scheduler.amazonaws.com"

  policy_statements = [
    {
      Effect   = "Allow"
      Action   = [
        "ecs:UpdateService",
        "ecs:DescribeServices"
      ]
      Resource = "*"
    }
  ]
}


data "terraform_remote_state" "platform" {
  backend = "remote"
  config = {
    organization = "edion-reconstruct"
    workspaces = {
      name = "edion-reconstruct-dev-03-app-platform"
    }
  }
}
data "terraform_remote_state" "app-web" {
  backend = "remote"
  config = {
    organization = "edion-reconstruct"
    workspaces = {
      name = "edion-reconstruct-dev-04-app-web"
    }
  }
}

locals {
  clusters             = data.terraform_remote_state.platform.outputs.cluster_arns
  ecs_service_name     = data.terraform_remote_state.app-web.outputs.ecs_service_names
}


module "app_stop_schedule" {
  source               = "../../modules/eventbridge_scheduler"
  schedule_name        = "edion-net-app-dev-stop-schedule"
  description          = "開発環境のECSサービスの登録を毎晩21:00 JSTに停止します。"
  cron_expression      = "cron(0 21 * * ? *)"
  role_arn             = module.iam_role_scheduler.role_arn
  target_cluster_arn   = local.clusters["cluster_1"]
  target_service_name  = local.ecs_service_name["registration_service"]
  target_task_count    = 0
}

module "manage_stop_schedule" {
  source               = "../../modules/eventbridge_scheduler"
  schedule_name        = "edion-net-app-dev-stop-manage-schedule"
  description          = "開発環境のECSサービスの登録を毎晩21:00 JSTに停止します。"
  cron_expression      = "cron(0 21 * * ? *)"
  role_arn             = module.iam_role_scheduler.role_arn
  target_cluster_arn   = local.clusters["cluster_2"]
  target_service_name  = local.ecs_service_name["manage_service"]
  target_task_count    = 0
}

module "app_start_schedule" {
  source               = "../../modules/eventbridge_scheduler"
  schedule_name        = "edion-net-app-dev-start-schedule"
  description          = "開発環境の管理ECSサービスを毎日09:00 JSTに開始します。"
  cron_expression      = "cron(0 9 * * ? *)"
  role_arn             = module.iam_role_scheduler.role_arn
  target_cluster_arn   = local.clusters["cluster_1"]
  target_service_name  = local.ecs_service_name["registration_service"]
  target_task_count    = 1
}

module "manage_start_schedule" {
  source               = "../../modules/eventbridge_scheduler"
  schedule_name        = "edion-net-app-dev-start-manage-schedule"
  description          = "開発環境の管理ECSサービスを毎日09:00 JSTに開始します。"
  cron_expression      = "cron(0 9 * * ? *)"
  role_arn             = module.iam_role_scheduler.role_arn
  target_cluster_arn   = local.clusters["cluster_2"]
  target_service_name  = local.ecs_service_name["manage_service"]
  target_task_count    = 1
}
