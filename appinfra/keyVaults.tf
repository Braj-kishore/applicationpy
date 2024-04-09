#-------------------------------------------------
# Using Azure verified module for network security groups.
#https://github.com/Azure/terraform-azurerm-avm-res-keyvault-vault
#--------------------------------------------------
module "avm-res-keyvault-vault" {
  source              = "Azure/avm-res-keyvault-vault/azurerm"
  version             = "0.5.3"
  name                = var.keyvault.name == null ? "kv-${local.resource_name_suffix}" : "${var.keyvault.name}"
  resource_group_name = azurerm_resource_group.rg[var.keyvault.resource_groups_map_key].name
  location            = azurerm_resource_group.rg[var.keyvault.resource_groups_map_key].location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  contacts            = var.contacts
  tags                = local.tags
  diagnostic_settings = {
    enable_diagnostic = {
      workspace_resource_id = module.operationalinsights-workspace.workspace_id.id
    }
  }
  network_acls     = var.network_acls
  role_assignments = local.role_assignments
  enable_telemetry = var.enable_telemetry
  depends_on       = [azurerm_linux_web_app.this]
}



