
#-------------------------------------------------
# Using Azure verified module for log analytics workspace.
#https://github.com/Azure/terraform-azurerm-avm-res-network-virtualnetwork
#--------------------------------------------------
module "operationalinsights-workspace" {
  source              = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version             = "0.1.3"
  name                = var.log_analytics_workspace.name
  resource_group_name = azurerm_resource_group.rg[var.log_analytics_workspace.resource_groups_map_key].name
  location            = azurerm_resource_group.rg[var.log_analytics_workspace.resource_groups_map_key].location
  tags                = local.tags
}