output "cluster_arns" {
  value = module.ecs.cluster_arns
}

output "task_definition_arns" {
  value = module.ecs_taskdefinition.task_definition_arns
}
