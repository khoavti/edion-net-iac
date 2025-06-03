pipelines = [
  {
    name                  = "edion-net-dev-app"
    repo_name             = "edion-net-dev-app-repository"
    image_repo_name       = "edion-net-dev-app-repository"
    codedeploy_app_name   = "edion-net-dev-app01"
    codedeploy_group_name = "edion-net-dev-app-deploy_group01"
    cluster_name          = "edion-net-dev-app-cluster01"
    service_name          = "edion-net-app-registration-dev-service"
    target_group_blue     = "edion-net-registration-tg-blue"
    target_group_green    = "edion-net-registration-tg-green"
    listener_arn          = "arn:aws:elasticloadbalancing:ap-northeast-1:968040114700:listener/app/dev-support-web/84459c316c768764/74cf8d19eedf0b81"
    account_id            = "968040114700"
  },
  {
    name                  = "edion-net-dev-mgt"
    repo_name             = "edion-net-dev-app-mgt-repository"
    image_repo_name       = "edion-net-dev-app-mgt-repository"
    codedeploy_app_name   = "edion-net-dev-mgt01"
    codedeploy_group_name = "edion-net-dev-mgt-deploy_group01"
    cluster_name          = "edion-net-dev-app-mgt-cluster01"
    service_name          = "edion-net-app-manage-dev-service"
    target_group_blue     = "edion-net-manage-tg-blue"
    target_group_green    = "edion-net-manage-tg-green"
    listener_arn          = "arn:aws:elasticloadbalancing:ap-northeast-1:968040114700:listener/app/dev-edion-isp-private-elb/9db6c27a3ebc3437/baa2f812175bfdba"
    account_id            = "968040114700"
  }
]
