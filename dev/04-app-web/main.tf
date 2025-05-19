module "code_deploy" {
  source = "../../modules/codedeploy"

  deployments = var.deployments
}

module "codebuild" {
  source = "../../modules/codebuild"

  codebuild_projects = var.codebuild_projects
}

module "code_pipeline" {
  source = "../../modules/codepipeline"

  pipelines = var.pipelines

  depends_on = [
    module.code_deploy,    # Đảm bảo CodeDeploy được tạo trước CodePipeline
    module.codebuild       # Đảm bảo CodeBuild được tạo trước CodePipeline
  ]
}
