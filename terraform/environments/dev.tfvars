location = "WestEurope"

keyvault = {
  name = "kv-dev-weu-001"
}

app_service_plan = {
  name = "asp"
}

subnets = {
  psqlsubnet = {
    vnet_name   = "vnet"
    subnet_name = "postgres-subnet-weu-001"
  }
  appsubnet = {
    vnet_name   = "vnet"
    subnet_name = "app-subnet-weu-001"
  }
}

postgresql_flexible_server = {
  name                     = "psql-poc-dev-weu-001"
  delegated_subnet_map_key = "psqlsubnet"
  private_dns_zone_map_key = "postgres"

}