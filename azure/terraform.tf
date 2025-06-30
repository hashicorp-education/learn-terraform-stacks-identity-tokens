terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.34"
    }
    archive = {
      source  = "hashicorp/azuread"
      version = "~> 3.4"
    }
  }

  required_version = ">= 1.2"
}
