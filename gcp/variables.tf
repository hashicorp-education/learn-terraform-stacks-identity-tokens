# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "gcp_project_id" {
  description = "GCP Project ID."
  type        = string
}

variable "hcp_organization_name" {
  description = "Organization name for the trust relationship."
  type        = string
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
