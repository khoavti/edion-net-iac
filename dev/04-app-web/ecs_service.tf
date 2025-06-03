data "terraform_remote_state" "platform" {
  backend = "remote"
  config = {
    organization = "edion-reconstruct"
    workspaces = {
      name = "edion-reconstruct-dev-03-app-platform"
    }
  }
}
data "terraform_remote_state" "security" {
  backend = "remote"
  config = {
    organization = "edion-reconstruct"
    workspaces = {
      name = "edion-reconstruct-dev-01-security"
    }
  }
}

locals {
  task_definition_arns = data.terraform_remote_state.platform.outputs.task_definition_arns
  clusters             = data.terraform_remote_state.platform.outputs.cluster_arns
  edion_net_app_ecs_dev_sg_id = data.terraform_remote_state.security.outputs.edion_net_app_ecs_dev_sg
  target_group_arn     = data.terraform_remote_state.security.outputs.target_group_arns
}


module "aws_ecs_service" {
  source = "../../modules/ecs_service"
  clusters = local.clusters
  services = {
    registration_service = {
      name                      = "edion-net-app-registration-dev-service"
      cluster_key               = "cluster_1"
      task_definition           = local.task_definition_arns["registration"]
      desired_count             = 2
      capacity_provider         = "FARGATE"
      capacity_provider_weight  = 2
      load_balancer = {
        target_group_arn = local.target_group_arn["registration-green"]
        container_name   = "registration-dev"
        container_port   = 80
      }
      network_configuration = {
        subnets          = ["subnet-02263bc2f812716c5", "subnet-0d6669975e094d327"]
        security_groups  = [local.edion_net_app_ecs_dev_sg_id]
        assign_public_ip = true
      }
    }
    manage_service = {
      name                      = "edion-net-app-manage-dev-service"
      cluster_key               = "cluster_2"
      task_definition           = local.task_definition_arns["manage"]
      desired_count             = 2
      capacity_provider         = "FARGATE"
      capacity_provider_weight  = 2
      load_balancer = {
        target_group_arn = local.target_group_arn["manage-green"]
        container_name   = "manage-dev"
        container_port   = 80
      }
      network_configuration = {
        subnets          = ["subnet-02263bc2f812716c5", "subnet-0d6669975e094d327"]
        security_groups  = [local.edion_net_app_ecs_dev_sg_id]
        assign_public_ip = true
      }
    }
  }
}

