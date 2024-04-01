

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "this" {
  for_each = var.resource_groups
  name     = "${each.value.name}-${local.resource_name_suffix}"
}

data "azurerm_service_plan" "this" {
  name                = "${var.app_service_plan.name}-${local.resource_name_suffix}"
  resource_group_name = data.azurerm_resource_group.this[var.app_service_plan.resource_groups_map_key].name
}

data "azurerm_subnet" "this" {
  for_each             = var.subnets
  name                 = each.value.subnet_name
  virtual_network_name = "${each.value.vnet_name}-${local.resource_name_suffix}"
  resource_group_name  = data.azurerm_resource_group.this[each.value.resource_groups_map_key].name
}

data "azurerm_private_dns_zone" "this" {
  for_each            = local.privatednszones
  name                = each.value
  resource_group_name = data.azurerm_resource_group.this["privateDnsZones"].name
}

data "azurerm_key_vault" "this" {
  name                = var.keyvault.name
  resource_group_name = data.azurerm_resource_group.this[var.keyvault.resource_groups_map_key].name
}

