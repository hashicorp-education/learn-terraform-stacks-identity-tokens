# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "aws_region" {
  type    = string
  default = "us_east_1"
}

variable "tfc_organization" {
  type = string
}

variable "tfc_project" {
  type = string
}

variable "tfc_hostname" {
  type = string
  default = "app.terraform.io"
}
