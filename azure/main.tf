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

resource "azuread_application_federated_identity_credential" "tfc_federated_credential_apply" {
  application_id = azuread_application.tfc_application.id
  display_name   = "my-tfc-federated-credential"
  audiences      = [var.tfc_azure_audience]
  issuer         = "https://${var.tfc_hostname}"
  subject        = "organization:${var.tfc_organization}:project:${var.tfc_project}:stack:*:*"
}
