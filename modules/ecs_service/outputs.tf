output "service_arns" {
  description = "Map of ECS service ARNs"
  value = {
    for key, svc in aws_ecs_service.services :
    key => svc.id
  }
}

output "service_names" {
  description = "Map of ECS service names"
  value = {
    for key, svc in aws_ecs_service.services :
    key => svc.name
  }
}

