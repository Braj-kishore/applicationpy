#-------------------------------------------------
# Using Azure verified module for network security groups.
#github.com/Azure/terraform-azurerm-avm-res-network-privatednszone
#--------------------------------------------------

module "avm-res-network-privatednszone" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "0.1.1"
  for_each            = local.privatednszones
  domain_name         = each.value
  resource_group_name = azurerm_resource_group.rg["privateDnsZones"].name
  virtual_network_links = { for key, value in var.VirtualNetworks : key => {
    vnetlinkname = value.vnet_name
    vnetid       = module.network[key].virtual_network_id
  } }
  enable_telemetry = var.enable_telemetry
  dns_zone_tags    = local.tags
}