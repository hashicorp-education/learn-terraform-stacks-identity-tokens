# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "tfc_organization" {
  type = string
}

variable "tfc_project" {
  type = string
}

variable "project_id" {
  type        = string
  description = "GCP Project ID"
}
