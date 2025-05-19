clusters = {
  cluster_1 = {
    name = "edion-net-dev-app-cluster01"
    container_insights = true
  },
  cluster_2 = {
    name = "edion-net-dev-app-mgt-cluster01"
    container_insights = true
  }
}

services = {
  registration_service = {
    name = "edion-net-app-registration-dev-service"
    cluster_key = "cluster_1"  # References the key in clusters map
    task_definition = "hello-world"
    desired_count = 1
    capacity_provider = "FARGATE"
    capacity_provider_weight = 2
    load_balancer = {
      target_group_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:555516925462:targetgroup/edion-net-app-re-dev-tg-blue/92761380670b2c3c"
      container_name = "test_cicd"
      container_port = 80
    }
    network_configuration = {
      subnets = ["subnet-08fa087aeea331f7b"]
      security_groups = ["sg-0872f0675f2f11948"]
      assign_public_ip = true
    }
  },
  manage_service = {
    name = "edion-net-app-manage-dev-service"
    cluster_key = "cluster_2"  # References the key in clusters map
    task_definition = "hello-world"
    desired_count = 1
    capacity_provider = "FARGATE"
    capacity_provider_weight = 2
    load_balancer = {
      target_group_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:555516925462:targetgroup/edion-net-app-ma-dev-tg-blue/809a95d9cffbbfba"
      container_name = "test_cicd"
      container_port = 80
    }
    network_configuration = {
      subnets = ["subnet-08fa087aeea331f7b"]
      security_groups = ["sg-0872f0675f2f11948"]
      assign_public_ip = true
    }
  }
}