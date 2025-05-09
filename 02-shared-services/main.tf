module "cloudwatch_log_groups" {
  source     = "../modules/cloudwatch-log-group"
  log_groups = var.log_groups
}
