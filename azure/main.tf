# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "azurerm" {
  features {}
}

provider "azuread" {
}

data "azurerm_subscription" "current" {
}

data "azuread_client_config" "current" {
}

resource "azuread_application" "tfc_application" {
  display_name = "tfc-application"
  owners       = [data.azuread_client_config.current.object_id] # check if needed
}

resource "azuread_service_principal" "tfc_service_principal" {
  client_id                    = azuread_application.tfc_application.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "tfc_role_assignment" {
  scope                = data.azurerm_subscription.current.id
  principal_id         = azuread_service_principal.tfc_service_principal.object_id
  role_definition_name = "Contributor"
}

resource "azuread_application_federated_identity_credential" "dev_plan" {
  application_id = azuread_application.tfc_application.id
  display_name   = "stacks-federated-credential"

  audiences = [var.azure_audience]
  issuer    = "https://${var.hcp_hostname}"
  subject   = "organization:${var.hcp_organization_name}:project:${var.hcp_project_name}:stack:${var.hcp_stack_name}:deployment:development:operation:plan"
}

resource "azuread_application_federated_identity_credential" "dev_apply" {
  application_id = azuread_application.tfc_application.id
  display_name   = "stacks-federated-credential"

  audiences = [var.azure_audience]
  issuer    = "https://${var.hcp_hostname}"
  subject   = "organization:${var.hcp_organization_name}:project:${var.hcp_project_name}:stack:${var.hcp_stack_name}:deployment:development:operation:plan"
}
