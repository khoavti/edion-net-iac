output "target_group_arns" {
  description = "Map of target group ARNs keyed by the target group name"
  value = {
    for key, tg in aws_lb_target_group.target_groups : key => tg.arn
  }
}
