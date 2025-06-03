output "ecs_service_arns" {
  description = "ARNs of ECS services"
  value       = module.aws_ecs_service.service_arns
}

output "ecs_service_names" {
  description = "Names of ECS services"
  value       = module.aws_ecs_service.service_names
}