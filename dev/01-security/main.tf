module "load_balancer" {
  source = "../../modules/load_balancer"
  
  target_groups = var.target_groups
}

module "security_group" {
  source = "../../modules/security_group"

  vpc_id       = var.vpc_id
  sg_name      = var.sg_name
  ingress_rules = var.ingress_rules
  egress_rules = var.egress_rules
}

data "aws_lb" "alb-isp-private" {
  arn = "arn:aws:elasticloadbalancing:ap-northeast-1:968040114700:loadbalancer/app/dev-edion-isp-private-elb/9db6c27a3ebc3437"
}

data "aws_lb_listener" "https_443" {
  load_balancer_arn = data.aws_lb.alb-isp-private.arn
  port              = 443
}


resource "aws_lb_listener_rule" "manage_domain_rule" {
  listener_arn = data.aws_lb_listener.https_443.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = module.load_balancer.target_group_arns["manage-green"]
  }

  condition {
    host_header {
      values = ["manage.domain"]
    }
  }
}



data "aws_lb" "alb_support" {
  arn = "arn:aws:elasticloadbalancing:ap-northeast-1:968040114700:loadbalancer/app/dev-support-web/84459c316c768764"
}

data "aws_lb_listener" "https_443_support" {
  load_balancer_arn = data.aws_lb.alb_support.arn  
  port              = 443
}

resource "aws_lb_listener_rule" "manage_domain_rule_support" {
  listener_arn = data.aws_lb_listener.https_443_support.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = module.load_balancer.target_group_arns["registration-green"]
  }

  condition {
    host_header {
      values = ["registration.domain"]
    }
  }
}

module "ecs_task_execution_role" {
  source = "../../modules/iam_role_generic"

  role_name       = "ecsTaskExecutionRole"
  trusted_service = "ecs-tasks.amazonaws.com"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]

  policy_statements = []
}

module "codebuild_role" {
  source = "../../modules/iam_role_generic"

  role_name       = "edion-net-dev-CodeBuildRole"
  trusted_service = "codebuild.amazonaws.com"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ]

  policy_statements = []
}

module "codedeploy_role" {
  source = "../../modules/iam_role_generic"

  role_name       = "codedeploy-service-role"
  trusted_service = "codedeploy.amazonaws.com"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS",
    "arn:aws:iam::aws:policy/IAMFullAccess"
  ]

  policy_statements = []
}

module "codepipeline_role" {
  source = "../../modules/iam_role_generic"

  role_name       = "edion-net-dev-codepipeline-role"
  trusted_service = "codepipeline.amazonaws.com"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess",
    "arn:aws:iam::aws:policy/AWSCodeStarFullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonECS_FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"

  ]

  policy_statements = []
}
