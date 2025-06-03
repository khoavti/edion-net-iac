output "cluster_arns" {
  value = { for k, v in aws_ecs_cluster.clusters : k => v.arn }
}
