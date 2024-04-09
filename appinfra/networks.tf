#-------------------------------------------------
# Using Azure verified module for network creation and subnets.
#https://github.com/Azure/terraform-azurerm-avm-res-network-virtualnetwork
#--------------------------------------------------

module "network" {
  source                        = "Azure/avm-res-network-virtualnetwork/azurerm"
  version                       = "0.1.4"
  for_each                      = var.VirtualNetworks
  name                          = "${each.value.vnet_name}-${local.resource_name_suffix}"
  resource_group_name           = azurerm_resource_group.rg[each.value.resource_groups_map_key].name
  location                      = azurerm_resource_group.rg[each.value.resource_groups_map_key].location
  virtual_network_address_space = each.value.virtual_network_address_space
  subnets = { for key, value in each.value.subnets : key => {
    address_prefixes                          = value.address_prefixes
    private_endpoint_network_policies_enabled = value.private_endpoint_network_policies_enabled
    service_endpoints                         = value.service_endpoints
    network_security_group                    = value.network_security_groups_map_key != null ? { id = module.networksecuritygroup[value.network_security_groups_map_key].nsg_resource.id } : null
    delegations                               = value.delegations
  } }
  enable_telemetry = var.enable_telemetry
  tags             = local.tags
}