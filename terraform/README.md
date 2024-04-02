<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.71.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.97.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_avm-web-site"></a> [avm-web-site](#module\_avm-web-site) | Azure/avm-res-web-site/azurerm | 0.2.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_postgresql_flexible_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_database.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) | resource |
| [random_password.rpassword](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/service_plan) | data source |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_service_plan"></a> [app\_service\_plan](#input\_app\_service\_plan) | n/a | <pre>object({<br>    name                    = string<br>    resource_groups_map_key = optional(string, "default")<br>    webapps = map(object({<br>      name         = string<br>      kind         = optional(string, "webapp")<br>      os_type      = optional(string, "Linux")<br>      app_settings = optional(map(string))<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment such as dev,UAT or prod | `string` | `"dev"` | no |
| <a name="input_keyvault"></a> [keyvault](#input\_keyvault) | n/a | <pre>object({<br>    name                    = optional(string)<br>    resource_groups_map_key = optional(string, "default")<br>  })</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resource group/resources is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace) | name of the log analytics workspce. | <pre>object({<br>    name                    = string<br>    resource_groups_map_key = optional(string, "default")<br>  })</pre> | n/a | yes |
| <a name="input_postgresql_flexible_server"></a> [postgresql\_flexible\_server](#input\_postgresql\_flexible\_server) | n/a | <pre>object({<br>    name                     = string<br>    resource_groups_map_key  = optional(string, "default")<br>    delegated_subnet_map_key = string<br>    private_dns_zone_map_key = string<br>    storage_tier             = optional(string, "P30")<br>    storage_mb               = optional(number, 32768)<br>    sku_name                 = optional(string, "GP_Standard_D4s_v3")<br>    zone                     = optional(number)<br>    databases = optional(list(object({<br>      name      = string<br>      charset   = optional(string, "utf8")<br>      collation = optional(string, "en_US.utf8")<br>    })), [])<br>  })</pre> | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of project for which the infra will create. | `string` | `"POC"` | no |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | map of object defines the details of the resource groups | <pre>map(object({<br>    name   = string<br>    region = optional(string)<br>  }))</pre> | <pre>{<br>  "default": {<br>    "name": "rg"<br>  },<br>  "network": {<br>    "name": "rg-network"<br>  },<br>  "privateDnsZones": {<br>    "name": "rg-dns"<br>  }<br>}</pre> | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | n/a | <pre>map(object({<br>    vnet_name               = string<br>    subnet_name             = string<br>    resource_groups_map_key = optional(string, "network")<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->