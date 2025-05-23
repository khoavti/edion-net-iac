resource "aws_codebuild_project" "codebuild_project" {
  for_each = var.codebuild_projects

  name         = each.value.project_name
  description  = each.value.description
  service_role = each.value.service_role
  build_timeout = 5
  queued_timeout = 5

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type         = "LINUX_CONTAINER"
  }
  logs_config {
    cloudwatch_logs {
      group_name =   each.value.log_name
      }
  }
  source {
    type     = "GITHUB"
    location = each.value.repository_url
    buildspec = each.value.buildspec
    auth {
      type     = "CODECONNECTIONS"
      resource = each.value.connection_arn
    }
  }
}
