data "aws_caller_identity" "current" {}

module "ecs" {
  source = "../../modules/ecs"
  
  clusters = var.clusters
  services = var.services
}