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

module "app_stop_schedule" {
  source               = "../../modules/eventbridge_scheduler"
  schedule_name        = "edion-net-app-dev-stop-schedule"
  description          = "開発環境のECSサービスの登録を毎晩21:00 JSTに停止します。"
  cron_expression      = "cron(0 21 * * ? *)"
  role_arn             = module.iam_role_scheduler.iam_role_arn
  target_cluster_arn   = "arn:aws:ecs:ap-northeast-1:555516925462:cluster/edion-net-dev-app-cluster01"
  target_service_name  = "edion-net-app-registration-dev-service"
  target_task_count    = 0
}

module "manage_stop_schedule" {
  source               = "../../modules/eventbridge_scheduler"
  schedule_name        = "edion-net-app-dev-stop-manage-schedule"
  description          = "開発環境のECSサービスの登録を毎晩21:00 JSTに停止します。"
  cron_expression      = "cron(0 21 * * ? *)"
  role_arn             = module.iam_role_scheduler.iam_role_arn
  target_cluster_arn   = "arn:aws:ecs:ap-northeast-1:555516925462:cluster/edion-net-dev-app-mgt-cluster01"
  target_service_name  = "edion-net-app-registration-dev-service"
  target_task_count    = 0
}

module "app_start_schedule" {
  source               = "../../modules/eventbridge_scheduler"
  schedule_name        = "edion-net-app-dev-start-schedule"
  description          = "開発環境の管理ECSサービスを毎日09:00 JSTに開始します。"
  cron_expression      = "cron(0 9 * * ? *)"
  role_arn             = module.iam_role_scheduler.iam_role_arn
  target_cluster_arn   = "arn:aws:ecs:ap-northeast-1:555516925462:cluster/edion-net-dev-app-cluster01"
  target_service_name  = "edion-net-app-dev-service"
  target_task_count    = 1
}

module "manage_start_schedule" {
  source               = "../../modules/eventbridge_scheduler"
  schedule_name        = "edion-net-app-dev-start-manage-schedule"
  description          = "開発環境の管理ECSサービスを毎日09:00 JSTに開始します。"
  cron_expression      = "cron(0 9 * * ? *)"
  role_arn             = module.iam_role_scheduler.iam_role_arn
  target_cluster_arn   = "arn:aws:ecs:ap-northeast-1:555516925462:cluster/edion-net-dev-app-mgt-cluster01"
  target_service_name  = "edion-net-app-manage-dev-service"
  target_task_count    = 1
}
