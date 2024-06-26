locals {
  resource_name_suffix = "${var.project_name}-${var.environment}-${var.location}-001"

  privatednszones = {
    postgres = "privatelink.postgres.database.azure.com"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }

  #psql_connection_string = "host=${azurerm_postgresql_flexible_server.this.fqdn};Database={_db_name};port=5432;username=${azurerm_postgresql_flexible_server.this.administrator_login};password=${random_password.rpassword.result};Ssl Mode=Require"
}