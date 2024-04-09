#-------------------------------------------------
# Create a resource group
#--------------------------------------------------
resource "azurerm_resource_group" "rg" {
  for_each = var.resource_groups
  name     = "${each.value.name}-${local.resource_name_suffix}"
  location = coalesce(each.value.region, var.location)
  tags     = local.tags
}