#-------------------------------------------------
# Using Azure verified module for network security groups.
#https://github.com/Azure/terraform-azurerm-avm-res-network-virtualnetwork
#--------------------------------------------------

module "networksecuritygroup" {
  source              = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version             = "0.1.1"
  for_each            = var.network_security_groups
  name                = each.value.name
  resource_group_name = azurerm_resource_group.rg[each.value.resource_groups_map_key].name
  location            = azurerm_resource_group.rg[each.value.resource_groups_map_key].location
  nsgrules            = each.value.rules
  tags                = local.tags
  enable_telemetry    = var.enable_telemetry
}