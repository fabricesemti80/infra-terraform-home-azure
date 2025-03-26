
/* -------------------------------------------------------------------------- */
/*                                  Variables                                 */
/* -------------------------------------------------------------------------- */
variable "location" {
  type = string
  default = "West Europe"
  description = "Azure deployment location (region)"

}

/* -------------------------------------------------------------------------- */
/*                                    Data                                    */
/* -------------------------------------------------------------------------- */
data "azurerm_client_config" "current" {}
data "azapi_client_config" "current" {}


/* -------------------------------------------------------------------------- */
/*                                  Resources                                 */
/* -------------------------------------------------------------------------- */
resource "azurerm_resource_group" "rg1" {
  name     = "rg1"
  location = var.location
}

# locals {
#   subscription_id            = data.azapi_client_config.current.subscription_id
#   resource_group_name        = azurerm_resource_group.rg1.name
#   resource_type              = "Microsoft.OperationalInsights/workspaces"
#   resource_names             = ["my-log-analytics-workspace"]
#   log_analytics_workspace_id = provider::azapi::resource_group_resource_id(
#     local.subscription_id,
#     local.resource_group_name,
#     local.resource_type,
#     local.resource_names
#   )
# }

/* -------------------------------------------------------------------------- */
/*                                Landing Zone                                */
/* -------------------------------------------------------------------------- */
module "alz" {

  /* --------------------------- Mandatory settings --------------------------- */
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "~> 0.10"
  location = var.location
  architecture_name  = "alz"
  parent_resource_id = data.azapi_client_config.current.tenant_id


  # policy_default_values = {
  #   log_analytics_workspace_id = jsonencode({ Value = local.log_analytics_workspace_id })
  # }
}
