# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "azure_region" {
  description = "Azure region for all resources."
  type        = string
  default     = "West US"
}

variable "azure_audience" {
  type        = string
  default     = "api://AzureADTokenExchange"
  description = "The audience value to use in run identity tokens."
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
