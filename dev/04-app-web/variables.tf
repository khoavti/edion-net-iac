variable "pipelines" {
  description = "A map of pipeline configurations"
  type = map(object({
    pipeline_name  = string
    role_arn      = string
    bucket_arn   = string
    repo_id        = string
    branch_name    = string
    project_name   = string
    app_name       = string
    deploy_group   = string
    connection_arn = string
  }))
}

variable "deployments" {
  description = "Map of deployment configurations"
  type = map(object({
    app_name           = string
    cluster_name       = string
    service_name       = string
    deployment_group   = string
    listener_arn = list(string)
    target_group_1 = string
    target_group_2 = string
  }))
}

variable "codebuild_projects" {
  description = "A map of CodeBuild project configurations"
  type = map(object({
    project_name   = string
    description    = string
    service_role   = string
    buildspec      = string
    repository_url = string
    connection_arn = string
    log_name       = string
  }))
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-1"
}
