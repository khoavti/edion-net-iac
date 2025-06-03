# Create ECS clusters
resource "aws_ecs_cluster" "clusters" {
  for_each = var.clusters
  
  name = each.value.name
  
  setting {
    name  = "containerInsights"
    value = each.value.container_insights 
  }
  configuration {
    execute_command_configuration {
      logging    = "OVERRIDE"
      log_configuration {
        cloud_watch_log_group_name = each.value.log_name
      }
    }
  }
}