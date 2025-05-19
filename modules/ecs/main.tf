# # Create KMS keys for each cluster
# resource "aws_kms_key" "keys" {
#   for_each = var.clusters

#   description             = each.value.kms_key.description
#   deletion_window_in_days = each.value.kms_key.deletion_window_in_days
#   key_usage               = "ENCRYPT_DECRYPT"
# }

# # Create KMS key aliases
# resource "aws_kms_alias" "aliases" {
#   for_each = var.clusters

#   name          = "alias/${each.value.kms_key.alias}"
#   target_key_id = aws_kms_key.keys[each.key].id
# }

# # Create KMS key policies
# resource "aws_kms_key_policy" "policies" {
#   for_each = var.clusters
  
#   key_id = aws_kms_key.keys[each.key].id
#   policy = jsonencode({
#     Id = "ECSClusterFargatePolicy"
#     Statement = [
#       {
#         Sid    = "Enable IAM User Permissions"
#         Effect = "Allow"
#         Principal = {
#           "AWS" : "*"
#         }
#         Action   = "kms:*"
#         Resource = "*"
#       },
#       {
#         Sid    = "Allow access for Key Administrators"
#         Effect = "Allow"
#         Principal = {
#           "AWS" : "*"
#         }
#         Action = [
#           "kms:Create*",
#           "kms:Describe*",
#           "kms:Enable*",
#           "kms:List*",
#           "kms:Put*",
#           "kms:Update*",
#           "kms:Revoke*",
#           "kms:Disable*",
#           "kms:Get*",
#           "kms:Delete*",
#           "kms:TagResource",
#           "kms:UntagResource",
#           "kms:ScheduleKeyDeletion",
#           "kms:CancelKeyDeletion",
#           "kms:RotateKeyOnDemand"
#         ]
#         Resource = "*"
#       },
#       {
#         Sid    = "Allow use of the key"
#         Effect = "Allow"
#         Principal = {
#           "AWS" : "*"
#         }
#         Action = [
#           "kms:Encrypt",
#           "kms:Decrypt",
#           "kms:ReEncrypt*",
#           "kms:GenerateDataKey*",
#           "kms:DescribeKey"
#         ]
#         Resource = "*"
#       },
#       {
#         Sid    = "Allow attachment of persistent resources"
#         Effect = "Allow"
#         Principal = {
#           "AWS" : "*"
#         }
#         Action = [
#           "kms:CreateGrant",
#           "kms:ListGrants",
#           "kms:RevokeGrant"
#         ]
#         Resource = "*"
#         Condition = {
#           "Bool" = {
#             "kms:GrantIsForAWSResource" = "true"
#           }
#         }
#       }
#     ]
#   })
# }

# Create ECS clusters
resource "aws_ecs_cluster" "clusters" {
  for_each = var.clusters
  
  name = each.value.name
  
  setting {
    name  = "containerInsights"
    value = each.value.container_insights ? "enabled" : "disabled"
  }

  # configuration {
  #   managed_storage_configuration {
  #     fargate_ephemeral_storage_kms_key_id = aws_kms_key.keys[each.key].id
  #   }
  # }
  
  # depends_on = [
  #   aws_kms_key_policy.policies
  # ]
}

# Create ECS services
resource "aws_ecs_service" "services" {
  for_each = var.services
  
  name            = each.value.name
  cluster         = aws_ecs_cluster.clusters[each.value.cluster_key].id
  task_definition = each.value.task_definition
  desired_count   = each.value.desired_count

  capacity_provider_strategy {
    capacity_provider = each.value.capacity_provider
    weight            = each.value.capacity_provider_weight
  }

  load_balancer {
    target_group_arn       = each.value.load_balancer.target_group_arn
    container_name = each.value.load_balancer.container_name
    container_port = each.value.load_balancer.container_port
  }
  
  network_configuration {
    subnets          = each.value.network_configuration.subnets
    security_groups  = each.value.network_configuration.security_groups
    assign_public_ip = each.value.network_configuration.assign_public_ip 
  }
  deployment_controller {
    type = "CODE_DEPLOY"
  }
}