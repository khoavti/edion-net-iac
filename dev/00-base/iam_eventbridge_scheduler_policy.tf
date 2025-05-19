resource "aws_iam_role" "eventbridge_scheduler_role" {
  name = "dev-eventbridge-scheduler-ecs-updateservice-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "scheduler.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "eventbridge_scheduler_ssm_policy" {
  name        = "eventbridge-scheduler-ssm-ecs-policy"
  description = "Allow EventBridge Scheduler to execute SSM automation to update ECS service count"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:StartAutomationExecution"
        ],
        Resource = "arn:aws:ssm:ap-northeast-1::automation-definition/AWS-UpdateECSServiceDesiredCount:*"
      },
      {
        Effect = "Allow",
        Action = [
          "iam:PassRole"
        ],
        Resource = aws_iam_role.eventbridge_scheduler_role.arn
      },
      {
        Effect = "Allow",
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices",
          "ecs:DescribeClusters",
          "ecs:ListServices",
          "ecs:ListClusters"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_eventbridge_scheduler_policy" {
  role       = aws_iam_role.eventbridge_scheduler_role.name
  policy_arn = aws_iam_policy.eventbridge_scheduler_ssm_policy.arn
}
