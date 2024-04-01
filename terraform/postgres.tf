
resource "random_password" "rpassword" {
  length           = 16
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  special          = true
  override_special = "_%@!$"
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                   = var.postgresql_flexible_server.name
  resource_group_name    = data.azurerm_resource_group.this[var.postgresql_flexible_server.resource_groups_map_key].name
  location               = data.azurerm_resource_group.this[var.postgresql_flexible_server.resource_groups_map_key].location
  version                = "12"
  delegated_subnet_id    = data.azurerm_subnet.this[var.postgresql_flexible_server.delegated_subnet_map_key].id
  private_dns_zone_id    = data.azurerm_private_dns_zone.this[var.postgresql_flexible_server.private_dns_zone_map_key].id
  administrator_login    = "psqladmin"
  administrator_password = random_password.rpassword.result
  zone                   = "1"

  storage_mb   = var.postgresql_flexible_server.storage_mb
  storage_tier = var.postgresql_flexible_server.storage_tier

  sku_name = var.postgresql_flexible_server.sku_name

}

resource "azurerm_postgresql_flexible_server_database" "example" {
  for_each  = { for value in var.postgresql_flexible_server.databases : value.name => value }
  name      = each.value.name
  server_id = azurerm_postgresql_flexible_server.this.id
  collation = each.value.collation
  charset   = each.value.charset

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

#saving postgres password in key vault
resource "azurerm_key_vault_secret" "example" {
  name         = "${var.postgresql_flexible_server.name}-password"
  value        = random_password.rpassword.result
  key_vault_id = data.azurerm_key_vault.this.id
}