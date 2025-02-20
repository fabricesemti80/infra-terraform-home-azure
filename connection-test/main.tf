
# resource "random_string" "random" {
#   length           = 8
#   special          = false
#   upper            = false
#   override_special = "/@£$"
# }

# resource "azurerm_resource_group" "example" {
#   name     = "example-resources"
#   location = "West Europe"
# }


# resource "azurerm_storage_account" "example" {
#   name                     = "testsa${random_string.random.result}"
#   resource_group_name      = azurerm_resource_group.example.name
#   location                 = azurerm_resource_group.example.location
#   account_tier             = "Standard"
#   account_replication_type = "GRS"

#   tags = {
#     environment = "staging"
#   }
# }