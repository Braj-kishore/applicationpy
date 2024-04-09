
resource "azurerm_service_plan" "this" {
  location                   = var.location
  name                       = var.app_service_plan.name != null ? "${var.app_service_plan.name}-${local.resource_name_suffix}" : "asp-${local.resource_name_suffix}"
  os_type                    = var.app_service_plan.os_type
  resource_group_name        = azurerm_resource_group.rg[var.app_service_plan.resource_groups_map_key].name
  sku_name                   = var.app_service_plan.sku_name
  app_service_environment_id = var.app_service_plan.app_service_environment_resource_id
  tags                       = local.tags
}
