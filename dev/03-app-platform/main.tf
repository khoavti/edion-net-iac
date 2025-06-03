module "ecs_taskdefinition" {
  source = "../../modules/ecs_taskdefinition"
  
  taskdefs = {
    manage = {
      family             = "manage-dev-taskdef"
      cpu                = "256"
      memory             = "512"
      network_mode       = "awsvpc"
      execution_role_arn = "arn:aws:iam::968040114700:role/ecsTaskExecutionRole"
      container_definitions = jsonencode([
        {
          name      = "manage-dev"
          image     = "968040114700.dkr.ecr.ap-northeast-1.amazonaws.com/edion-net-dev-app-mgt-repository:latest"
          essential = true
          portMappings = [
            {
              containerPort = 80
              protocol      = "tcp"
            }
          ]
          logConfiguration = {
            logDriver = "awslogs"
            options = {
              "awslogs-group"         = "/edion-net-dev/app-mgt/container-app-logs"
              "awslogs-region"        = "ap-northeast-1"
              "awslogs-stream-prefix" = "ecs"
            }
          }
        }
      ])
    }
    registration = {
      family             = "registration-dev-taskdef"
      cpu                = "256"
      memory             = "512"
      network_mode       = "awsvpc"
      execution_role_arn = "arn:aws:iam::968040114700:role/ecsTaskExecutionRole"
      container_definitions = jsonencode([
        {
          name      = "registration-dev"
          image     = "968040114700.dkr.ecr.ap-northeast-1.amazonaws.com/edion-net-dev-app-repository:latest"
          essential = true
          portMappings = [
            {
              containerPort = 80
              protocol      = "tcp"
            }
          ]
          logConfiguration = {
            logDriver = "awslogs"
            options = {
              "awslogs-group"         = "/edion-net-dev/app/container-app-logs"
              "awslogs-region"        = "ap-northeast-1"
              "awslogs-stream-prefix" = "ecs"
            }
          }
        }
      ])
    }
  }
}

module "ecs" {
  source = "../../modules/ecs"

  clusters = var.clusters
}