# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "hcp_organization_name" {
  description = "Organization name for the trust relationship."
  type = string
}

variable "hcp_project_name" {
  description = "Project name for the trust relationship."
  type        = string
}

variable "hcp_hostname" {
  description = "Hostname of HCP Terraform or Terraform Enterprise."
  type        = string
  default     = "app.terraform.io"
}
