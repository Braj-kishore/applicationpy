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
  resource_group_name = data.azurerm_resource_group.this[var.app_service_plan.resource_groups_map_key].name
  location            = data.azurerm_resource_group.this[var.app_service_plan.resource_groups_map_key].location
  service_plan_id     = data.azurerm_service_plan.this.id
  app_settings = merge(each.value.app_settings, {
    psqladminuser     = "psqladmin"
    psqladminpassword = "${random_password.rpassword.result}"
    psqlhosturl       = azurerm_postgresql_flexible_server.this.fqdn
  })
  site_config {
    application_stack {
      python_version = "3.11"
    }
  }
  tags = local.tags
}