location        = "westus"
VirtualNetworks = {}

environment = "staging"

network_security_groups = {}

keyvault = {
  name = "kv-onearc-stg-wus-002"
}

app_service_plan = {
  name = "asp"
  webapps = {
    one_arc = {
      name = "app"
    }
  }
}

log_analytics_workspace = {
  name = "law-staging-wus-001"
}

postgresql_flexible_server = {
  name = "psql-onearc-staging-wus-001"
  # delegated_subnet_map_key = "psqlsubnet"
  # private_dns_zone_map_key = "postgres"
  databases = [{
    name = "one_arc"
  }]
}

