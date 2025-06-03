variable "pipelines" {
  description = "List of CodePipeline ECS Blue/Green configurations"
  type = list(object({
    name                  = string
    repo_name             = string
    image_repo_name       = string
    codedeploy_app_name   = string
    codedeploy_group_name = string
    cluster_name          = string
    service_name          = string
    target_group_blue     = string
    target_group_green    = string
    listener_arn          = string
    account_id            = string
  }))
}
