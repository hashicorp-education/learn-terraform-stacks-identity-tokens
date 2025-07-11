# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "google" {
  region  = "global"
  project = var.gcp_project_id
}

resource "google_service_account" "terraform_stacks_sa" {
  account_id   = local.resource_name

  project = var.gcp_project_id
}

resource "random_pet" "workload_identity_name" {
  length = 2
  separator = "-"
}

locals {
  gcp_service_list = [
    "sts.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com"
  ]

  resource_name = substr("${random_pet.workload_identity_name.id}", 0, 15)
}

resource "google_project_service" "services" {
  for_each                   = toset(local.gcp_service_list)
  project                    = var.gcp_project_id
  service                    = each.key
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_iam_workload_identity_pool" "terraform_stacks_pool" {
  depends_on                = [google_project_service.services]
  workload_identity_pool_id = local.resource_name

  project = var.gcp_project_id
}

resource "google_iam_workload_identity_pool_provider" "terraform_stacks_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.terraform_stacks_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "stacks"

  description                        = "OIDC identity pool provider for Terraform Stacks"

  attribute_mapping = {
    "google.subject"                            = "assertion.sub",
    "attribute.aud"                             = "assertion.aud",
    "attribute.terraform_operation"             = "assertion.terraform_operation",
    "attribute.terraform_project_id"            = "assertion.terraform_project_id",
    "attribute.terraform_project_name"          = "assertion.terraform_project_name",
    "attribute.terraform_stack_id"              = "assertion.terraform_stack_id",
    "attribute.terraform_stack_name"            = "assertion.terraform_stack_name",
    "attribute.terraform_stack_deployment_name" = "assertion.terraform_stack_deployment_name",
    "attribute.terraform_organization_id"       = "assertion.terraform_organization_id",
    "attribute.terraform_organization_name"     = "assertion.terraform_organization_name",
    "attribute.terraform_run_id"                = "assertion.terraform_run_id",
  }
  oidc {
    issuer_uri        = "https://app.terraform.io"
    allowed_audiences = ["hcp.workload.identity"]
  }

  attribute_condition = "assertion.sub.startsWith(\"organization:${var.hcp_organization_name}:project:${var.hcp_project_name}:stack\")"
}

resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.terraform_stacks_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.terraform_stacks_pool.name}/*"
}

resource "google_project_iam_member" "sa_more_permissions" {
  project = var.gcp_project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.terraform_stacks_sa.email}"
}

resource "google_project_iam_member" "sa_editor" {
  project = var.gcp_project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.terraform_stacks_sa.email}"
}
