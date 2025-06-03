locals {
  role_arns = data.terraform_remote_state.security.outputs.role_arns
}

resource "aws_codebuild_project" "app_build" {
  for_each = { for p in var.pipelines : p.name => p }

  name          = "${each.value.name}-project"
  service_role  = local.role_arns["codebuild"]
  description   = "Build and push image for ECS for ${each.value.name}"
  build_timeout = 30

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_REGION"
      value = "ap-northeast-1"
    }
    environment_variable {
      name  = "ACCOUNT_ID"
      value = each.value.account_id
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = each.value.image_repo_name
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}

resource "aws_codedeploy_app" "ecs_app" {
  for_each = { for p in var.pipelines : p.name => p }

  name             = each.value.codedeploy_app_name
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "ecs_group" {
  for_each = { for p in var.pipelines : p.name => p }

  app_name              = aws_codedeploy_app.ecs_app[each.key].name
  deployment_group_name = each.value.codedeploy_group_name
  service_role_arn      = local.role_arns["codedeploy"]
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action                         = "TERMINATE"
      termination_wait_time_in_minutes = 0
    }

    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
  }

  ecs_service {
    cluster_name = each.value.cluster_name
    service_name = each.value.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = each.value.target_group_green
      }
      target_group {
        name = each.value.target_group_blue
      }
      prod_traffic_route {
        listener_arns = [each.value.listener_arn]
      }
    }
  }

  depends_on = [
    module.aws_ecs_service
  ]
}

resource "aws_codepipeline" "ecs_pipeline" {
  for_each = { for p in var.pipelines : p.name => p }

  name     = "${each.value.name}-codepipeline"
  role_arn = local.role_arns["codepipeline"]

  artifact_store {
    location = aws_s3_bucket.artifact.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn        = data.aws_codestarconnections_connection.github.arn
        FullRepositoryId     = "khoavti/${each.value.repo_name}"
        BranchName           = "main"
        OutputArtifactFormat = "CODE_ZIP"
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
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.app_build[each.key].name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        ApplicationName                = aws_codedeploy_app.ecs_app[each.key].name
        DeploymentGroupName            = aws_codedeploy_deployment_group.ecs_group[each.key].deployment_group_name
        TaskDefinitionTemplateArtifact = "BuildArtifact"
        TaskDefinitionTemplatePath     = "taskdef.json"
        AppSpecTemplateArtifact        = "BuildArtifact"
        AppSpecTemplatePath            = "appspec.yaml"
      }
    }
  }
}
