## 1. Comment-out the backend-block and run "terraform apply" => this will create the storage account and the storage container
## 2. Uncomment the backend-block and run `terraform init --migrate-state' to migrate the state file to the storage account
## 3. Start using terraform as normal

locals {
  sa_name = "tfstatestorageaccountfs"
  ct_name = "tfstate"
}
terraform {
  backend "azurerm" {
        resource_group_name  = "tfstate"
        storage_account_name = local.sa_name
        container_name       = local.ct_name
        key                  = "terraform.tfstate"
    }
}

resource "azurerm_resource_group" "tfstate" {
  name     = "tfstate"
  location = "West Europe"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = local.sa_name
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
#   public_network_access_enabled = false

}

resource "azurerm_storage_container" "tfstate" {
  depends_on = [ azurerm_storage_account.tfstate ]
  name                  = local.ct_name
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}