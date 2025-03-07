# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.22.0"
    }
  }
}
provider "azurerm" {
  features {}
  use_msi = false
}


