variable "pipelines" {
  description = "A map of pipeline configurations"
  type = map(object({
    pipeline_name  = string
    role_arn      = string
    bucket_arn    = string
    repo_id        = string
    branch_name    = string
    project_name   = string
    app_name       = string
    deploy_group   = string
    connection_arn = string
  }))
}
