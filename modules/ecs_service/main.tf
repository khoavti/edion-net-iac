# Create ECS services
resource "aws_ecs_service" "services" {
  for_each = var.services
  
  name            = each.value.name
  cluster         = var.clusters[each.value.cluster_key]
  task_definition = each.value.task_definition
  desired_count   = each.value.desired_count

  capacity_provider_strategy {
    capacity_provider = each.value.capacity_provider
    weight            = each.value.capacity_provider_weight
  }

  load_balancer {
    target_group_arn       = each.value.load_balancer.target_group_arn
    container_name = each.value.load_balancer.container_name
    container_port = each.value.load_balancer.container_port
  }
  
  network_configuration {
    subnets          = each.value.network_configuration.subnets
    security_groups  = each.value.network_configuration.security_groups
    assign_public_ip = each.value.network_configuration.assign_public_ip 
  }
  deployment_controller {
    type = "CODE_DEPLOY"
  }
}