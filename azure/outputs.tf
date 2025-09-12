# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

output "client_id" {
  value = data.azuread_client_config.current.client_id
}

output "tenant_id" {
  value = data.azurerm_subscription.current.tenant_id
}
