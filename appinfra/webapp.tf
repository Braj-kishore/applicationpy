#-------------------------------------------------
# Using Azure verified module for network security groups.
#https:// github.com/Azure/terraform-azurerm-avm-res-web-site 
#--------------------------------------------------


# module "avm-web-site" {
#   source                   = "Azure/avm-res-web-site/azurerm"
#   version                  = "0.2.0"
#   for_each                 = var.app_service_plan.webapps
#   kind                     = each.value.kind
#   location                   = data.azurerm_resource_group.this[var.app_service_plan.resource_groups_map_key].location
#   name                     = "${each.value.name}-${local.resource_name_suffix}"
#   os_type                  = each.value.os_type
#   resource_group_name      = data.azurerm_resource_group.this[var.app_service_plan.resource_groups_map_key].name
#   app_settings             = each.value.app_settings
#   service_plan_resource_id = data.azurerm_service_plan.this.id
#   site_config = {
#     application_stack = {
#       app_stack = { python_version = "3.11" }
#     }
#   }

#   diagnostic_settings = {
#     enable_diagnostic = {
#       workspace_resource_id = data.azurerm_log_analytics_workspace.this.id
#     }
#   }
# }

resource "azurerm_linux_web_app" "this" {
  for_each            = var.app_service_plan.webapps
  name                = "${each.value.name}-${local.resource_name_suffix}"
  resource_group_name = azurerm_resource_group.rg[var.app_service_plan.resource_groups_map_key].name.name
  location            = azurerm_resource_group.rg[var.app_service_plan.resource_groups_map_key].name.location
  service_plan_id     = azurerm_service_plan.this.id
  app_settings = merge(each.value.app_settings, {
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
    KEY_VAULT_NAME                 = try(var.keyvault.name, null)
  })
  site_config {
    application_stack {
      python_version = "3.11"
    }
  }
  identity {
    type = "SystemAssigned"
  }
  tags = local.tags
}

resource "azurerm_monitor_diagnostic_setting" "web_app" {
  for_each                   = var.app_service_plan.webapps
  name                       = split("/", module.operationalinsights-workspace.workspace_id.id)[length(split("/", module.operationalinsights-workspace.workspace_id.id)) - 1]
  target_resource_id         = azurerm_linux_web_app.this[each.key].id
  log_analytics_workspace_id = module.operationalinsights-workspace.workspace_id.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }

  dynamic "enabled_log" {
    for_each = local.web_app_logs
    content {
      category = enabled_log.value
    }
  }
}