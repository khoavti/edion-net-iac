# Data source for existing load balancer
# Create target groups using for_each
resource "aws_lb_target_group" "target_groups" {
  for_each = var.target_groups

  name        = substr(each.value.name, 0, 32)
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = each.value.vpc_id
  target_type = each.value.target_type

}

