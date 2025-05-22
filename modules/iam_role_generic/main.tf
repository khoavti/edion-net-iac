resource "aws_iam_role" "this" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = var.trusted_service
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "this" {
  name   = "${var.role_name}-inline-policy"
  role   = aws_iam_role.this.id
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = var.policy_statements
  })
}

output "iam_role_arn" {
  value = aws_iam_role.this.arn
}
