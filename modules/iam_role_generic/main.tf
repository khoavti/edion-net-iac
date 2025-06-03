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
  count  = length(var.policy_statements) > 0 ? 1 : 0
  name   = "${var.role_name}-inline-policy"
  role   = aws_iam_role.this.id
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = var.policy_statements
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(var.managed_policy_arns)
  role     = aws_iam_role.this.name
  policy_arn = each.value
}
