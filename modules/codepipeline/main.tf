resource "aws_codepipeline" "codepipeline" {
  for_each = var.pipelines

  name     = each.value.pipeline_name
  role_arn = each.value.role_arn

  artifact_store {
    type     = "S3"
    location = each.value.bucket_arn
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn    = each.value.connection_arn
        FullRepositoryId = each.value.repo_id
        BranchName       = each.value.branch_name
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = each.value.project_name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "CodeDeploy"
      version          = "1"
      input_artifacts  = ["build_output"]
      configuration = {
        ApplicationName     = each.value.app_name
        DeploymentGroupName = each.value.deploy_group
      }
    }
  }
}
