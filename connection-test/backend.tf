##? LOCAL backend? 
## --> COMMENT the `backend "azurerm" {)` blocks - this is the default setting, so no definition required
## MUST do this for the initial setup !!

##? AZURERM backend?
## UNCOMMENT the `backend "azurerm" {)` block (ensure there is no other contradicting blocks!)

##? REMOTE backend?
## UNCOMMENT the `backend "remote" {}` block (ensure there is no other contradicting blocks!)
## https://app.terraform.io - obtain and update your organization and workspace 
## execute `terraform login` (will generate an API key, or you can use existing one maybe...)

#! To change between backends, after each modification run `terraform init -migrate-state`


terraform {

  # backend "azurerm" {
  #   resource_group_name  = "tfstate-rg"
  #   storage_account_name = "tfstatestorageaccountfs" # local.sa_name
  #   container_name       = "tfstate"                 # local.ct_name
  #   key                  = "terraform.tfstate"
  # }

  backend "remote" {
    organization = "homelab-fsemti" # org name from step 2.
    workspaces {
      name = "clouds-az" # name for your app's state.
    }
  }
}

locals {
  sa_name     = "tfstatestorageaccountfs"
  ct_name     = "tfstate"
  rg_name     = "tfstate-rg"
  rg_location = "West Europe"
}

resource "azurerm_resource_group" "tfstate" {
  name     = local.rg_name
  location = local.rg_location
}

resource "azurerm_storage_account" "tfstate" {
  name                            = local.sa_name
  resource_group_name             = azurerm_resource_group.tfstate.name
  location                        = azurerm_resource_group.tfstate.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true
}

resource "azurerm_storage_container" "tfstate" {
  depends_on         = [azurerm_storage_account.tfstate]
  name               = local.ct_name
  storage_account_id = azurerm_storage_account.tfstate.id
  # storage_account_name  = local.sa_name
  container_access_type = "private"
}
