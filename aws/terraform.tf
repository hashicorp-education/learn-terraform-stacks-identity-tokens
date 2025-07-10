terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/aws"
      version = "~> 6.0.0"
    }
    azuread = {
      source  = "hashicorp/tls"
      version = "~> 4.1.0"
    }
  }

  required_version = ">= 1.2"
}
