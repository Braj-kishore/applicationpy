#-------------------------------------------------
# Using Azure verified module for network security groups.
#https:// github.com/Azure/terraform-azurerm-avm-res-web-site 
#--------------------------------------------------


module "avm-web-site" {
  source                   = "Azure/avm-res-web-site/azurerm"
  version                  = "0.2.0"
  for_each                 = var.app_service_plan.webapps
  kind                     = each.value.webapps.kind
  name                     = "${each.value.webapps.name}-${local.resource_name_suffix}"
  os_type                  = each.value.webapps.os_type
  resource_group_name      = data.azurerm_resource_group.this[each.value.resource_groups_map_key].name
  app_settings             = each.value.webapps.app_settings
  service_plan_resource_id = data.azurerm_service_plan.this.id
  site_config = {
    application_stack = {
      app_stack = { python_version = "3.11" }
    }
  }

  diagnostic_settings = {
    enable_diagnostic = {
      workspace_resource_id = data.azurerm_log_analytics_workspace.this.id
    }
  }
}