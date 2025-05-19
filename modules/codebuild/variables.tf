variable "codebuild_projects" {
  description = "A map of CodeBuild project configurations"
  type = map(object({
    project_name   = string
    description    = string
    service_role   = string
    buildspec      = string
    repository_url = string
    connection_arn = string
  }))
}
