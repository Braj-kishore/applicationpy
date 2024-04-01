locals {
  resource_name_suffix = "${var.project_name}-${var.environment}-${var.location}-001"

  privatednszones = {
    postgres = "privatelink.postgres.database.azure.com"
  }
}