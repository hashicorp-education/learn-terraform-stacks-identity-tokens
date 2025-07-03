# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "role_arn" {
  description = "ARN of the IAM role that Stacks will use to provision resources."
  value       = aws_iam_role.stacks_role.arn
}
