output "codebuild_project_names" {
  description = "The names of the CodeBuild projects"
  value       = { for key, project in aws_codebuild_project.codebuild_project : key => project.name }
}

output "codebuild_project_arns" {
  description = "The ARNs of the CodeBuild projects"
  value       = { for key, project in aws_codebuild_project.codebuild_project : key => project.arn }
}
