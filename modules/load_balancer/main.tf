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

# Create HTTPS listener
resource "aws_lb_listener" "listeners" {
  for_each = var.listener  # Lặp qua các listener từ var.listener

  depends_on        = [aws_lb_target_group.target_groups]
  load_balancer_arn = each.value.elb_arn
  protocol          = each.value.protocol
  port              = each.value.port

  default_action {
    type = each.value.default_action.type

    forward {
      dynamic "target_group" {
        for_each = each.value.default_action.default_target_groups  # Duyệt qua các target group
        content {
          arn = aws_lb_target_group.target_groups[target_group.value].arn
        }
      }
    }
  }
}


# Create listener rules using for_each
resource "aws_lb_listener_rule" "listener_rules" {
  for_each = var.listener_rules

  listener_arn = aws_lb_listener.listeners[each.value.listener_key].arn
  priority     = each.value.priority

  action {
    type = "forward"

    forward {
      dynamic "target_group" {
        for_each = each.value.forward_targets
        content {
          arn    = aws_lb_target_group.target_groups[target_group.value.target_group_key].arn
          weight = target_group.value.weight
        }
      }
    }
  }

  condition {
    host_header {
      values = each.value.condition.host_header
    }
  }
}
