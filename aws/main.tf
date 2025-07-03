# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.aws_region
}

data "tls_certificate" "hcp_certificate" {
  url = "https://${var.hcp_hostname}"
}

resource "aws_iam_openid_connect_provider" "stacks_openid_provider" {
  url            = "https://${var.hcp_hostname}"
  client_id_list = ["aws.workload.identity"]

  thumbprint_list = [data.tls_certificate.hcp_certificate.certificates[0].sha1_fingerprint]
}

resource "aws_iam_role" "stacks_role" {
  name               = substr(replace("stacks-${var.hcp_organization_name}-${var.hcp_project_name}", "/[^\\w+=,.@-]/", "-"), 0, 64)
  assume_role_policy = data.aws_iam_policy_document.stacks_role_policy.json
}

data "aws_iam_policy_document" "stacks_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.stacks_openid_provider.arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "app.terraform.io:aud"
      values   = ["aws.workload.identity"]
    }
    condition {
      test     = "StringLike"
      variable = "app.terraform.io:sub"
      values   = ["organization:${var.hcp_organization_name}:project:${var.hcp_project_name}:stack:*:*"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "iam" {
  role       = aws_iam_role.stacks_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "sudo" {
  role       = aws_iam_role.stacks_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}
