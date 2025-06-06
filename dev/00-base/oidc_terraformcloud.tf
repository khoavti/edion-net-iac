
/*
terraform cloudでのplan/apply用iam role
*/
locals {
  terraform_cloud = {
    hostname          = "app.terraform.io"
    organization_name = var.organization_name
    project_name      = var.project_name
    workspace_name    = "*"
  }
}

data "tls_certificate" "tfc_certificate" {
  url = "https://${local.terraform_cloud.hostname}"
}

resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = data.tls_certificate.tfc_certificate.url
  client_id_list  = ["aws.workload.identity"]
  thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
}

data "aws_iam_policy_document" "tfc_oid_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.tfc_provider.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.terraform_cloud.hostname}:aud"
      values   = ["${one(aws_iam_openid_connect_provider.tfc_provider.client_id_list)}"]
    }
    condition {
      test     = "StringLike"
      variable = "${local.terraform_cloud.hostname}:sub"
      values   = ["organization:${local.terraform_cloud.organization_name}:project:${local.terraform_cloud.project_name}:workspace:${local.terraform_cloud.workspace_name}:run_phase:*"]
    }
  }
}

resource "aws_iam_role" "tfc_role" {
  name               = var.iam_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.tfc_oid_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "tfc_policy_attachment" {
  for_each = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }
  role       = aws_iam_role.tfc_role.name
  policy_arn = each.value
}