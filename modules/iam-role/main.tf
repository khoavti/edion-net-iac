resource "aws_iam_role" "this" {
  name = "${var.environment}-eventbridge-scheduler-ecs-updateservice-role"

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

resource "aws_iam_role_policy" "this" {
  name = "${var.environment}-eventbridge-scheduler-policy"
  role = aws_iam_role.this.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
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
