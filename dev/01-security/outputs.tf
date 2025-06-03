output "role_arns" {
  value = {
    codebuild   = module.codebuild_role.role_arn
    codedeploy  = module.codedeploy_role.role_arn
    codepipeline = module.codepipeline_role.role_arn
  }
}

output "edion_net_app_ecs_dev_sg" {
  value = module.security_group.edion_net_app_ecs_dev_sg_id
}

output "target_group_arns" {
  description = "Map of target group ARNs keyed by the target group name from load_balancer module"
  value       = module.load_balancer.target_group_arns
}
