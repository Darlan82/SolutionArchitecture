provider "azurerm" {
  features {}
  tenant_id = "779f8684-b294-4046-a8f2-e55213029544"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0.0"
}