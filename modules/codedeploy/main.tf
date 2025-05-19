resource "aws_codedeploy_app" "ecs_application" {
  for_each = var.deployments

  name             = each.value.app_name
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "ecs_deployment_group" {
  for_each = var.deployments

  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  app_name               = aws_codedeploy_app.ecs_application[each.key].name
  deployment_group_name  = each.value.deployment_group
  service_role_arn       = "arn:aws:iam::555516925462:role/CodeDeployServiceRole"

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  ecs_service {
    cluster_name = each.value.cluster_name
    service_name = each.value.service_name
  }

  
  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = each.value.listener_arn
      }

      target_group {
        name = each.value.target_group_1
      }

      target_group {
        name = each.value.target_group_2
      }
    }
  }
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }
}
