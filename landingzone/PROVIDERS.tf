terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>2.2.0"
    }
  }
}

provider "azurerm" {
  features {}
}