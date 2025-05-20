resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(var.policy_arns)
  role     = aws_iam_role.this.name
  policy_arn = each.value
}

output "iam_role_name" {
  value = aws_iam_role.this.name
}

output "iam_role_arn" {
  value = aws_iam_role.this.arn
}
