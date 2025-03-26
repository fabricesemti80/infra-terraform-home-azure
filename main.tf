/* -------------------------------------------------------------------------- */
/*                                   Example                                  */
/* -------------------------------------------------------------------------- */

resource "random_string" "random" {
  length           = 8
  special          = false
  upper            = false
  override_special = "/@£$"
}

resource "azurerm_resource_group" "example" {
  name     = "rg-example"
  location = "West Europe"
}


resource "azurerm_storage_account" "example" {
  name                     = "sa${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "development"
  }
}

/* -------------------------------------------------------------------------- */
/*                                  To delete                                 */
/* -------------------------------------------------------------------------- */

# resource "azurerm_resource_group" "management" {
#   name     = "rg-management-westeurope"
#   location = "West Europe"
# }
