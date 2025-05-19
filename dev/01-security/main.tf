module "load_balancer" {
  source = "../../modules/load_balancer"
  
  target_groups = var.target_groups
  listener = var.listener
  listener_rules = var.listener_rules
}

module "security_group" {
  source = "../../modules/security_group"

  vpc_id       = var.vpc_id
  sg_name      = var.sg_name
  ingress_rules = var.ingress_rules
  egress_rules = var.egress_rules
}
