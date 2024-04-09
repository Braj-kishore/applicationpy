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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.71.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_avm-res-keyvault-vault"></a> [avm-res-keyvault-vault](#module\_avm-res-keyvault-vault) | Azure/avm-res-keyvault-vault/azurerm | 0.5.3 |
| <a name="module_avm-res-network-privatednszone"></a> [avm-res-network-privatednszone](#module\_avm-res-network-privatednszone) | Azure/avm-res-network-privatednszone/azurerm | 0.1.1 |
| <a name="module_network"></a> [network](#module\_network) | Azure/avm-res-network-virtualnetwork/azurerm | 0.1.4 |
| <a name="module_networksecuritygroup"></a> [networksecuritygroup](#module\_networksecuritygroup) | Azure/avm-res-network-networksecuritygroup/azurerm | 0.1.1 |
| <a name="module_operationalinsights-workspace"></a> [operationalinsights-workspace](#module\_operationalinsights-workspace) | Azure/avm-res-operationalinsights-workspace/azurerm | 0.1.3 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_web_app.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |
| [azurerm_monitor_diagnostic_setting.web_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_postgresql_flexible_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_database.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [random_password.rpassword](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_VirtualNetworks"></a> [VirtualNetworks](#input\_VirtualNetworks) | Create virtual network and subnets. In subnets map of object key is the name of the subnets. | <pre>map(object({<br>    vnet_name                     = string<br>    resource_groups_map_key       = optional(string, "network")<br>    virtual_network_address_space = list(string)<br>    subnets = map(object({<br>      address_prefixes                          = list(string)<br>      private_endpoint_network_policies_enabled = optional(bool, false)<br>      service_endpoints                         = optional(set(string))<br>      network_security_groups_map_key           = optional(string)<br>      delegations = optional(list(<br>        object(<br>          {<br>            name = string # (Required) A name for this delegation.<br>            service_delegation = object({<br>              name    = string                 # (Required) The name of service to delegate to. Possible values include `Microsoft.ApiManagement/service`, `Microsoft.AzureCosmosDB/clusters`, `Microsoft.BareMetal/AzureVMware`, `Microsoft.BareMetal/CrayServers`, `Microsoft.Batch/batchAccounts`, `Microsoft.ContainerInstance/containerGroups`, `Microsoft.ContainerService/managedClusters`, `Microsoft.Databricks/workspaces`, `Microsoft.DBforMySQL/flexibleServers`, `Microsoft.DBforMySQL/serversv2`, `Microsoft.DBforPostgreSQL/flexibleServers`, `Microsoft.DBforPostgreSQL/serversv2`, `Microsoft.DBforPostgreSQL/singleServers`, `Microsoft.HardwareSecurityModules/dedicatedHSMs`, `Microsoft.Kusto/clusters`, `Microsoft.Logic/integrationServiceEnvironments`, `Microsoft.MachineLearningServices/workspaces`, `Microsoft.Netapp/volumes`, `Microsoft.Network/managedResolvers`, `Microsoft.Orbital/orbitalGateways`, `Microsoft.PowerPlatform/vnetaccesslinks`, `Microsoft.ServiceFabricMesh/networks`, `Microsoft.Sql/managedInstances`, `Microsoft.Sql/servers`, `Microsoft.StoragePool/diskPools`, `Microsoft.StreamAnalytics/streamingJobs`, `Microsoft.Synapse/workspaces`, `Microsoft.Web/hostingEnvironments`, `Microsoft.Web/serverFarms`, `NGINX.NGINXPLUS/nginxDeployments` and `PaloAltoNetworks.Cloudngfw/firewalls`.<br>              actions = optional(list(string)) # (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values include `Microsoft.Network/networkinterfaces/*`, `Microsoft.Network/virtualNetworks/subnets/action`, `Microsoft.Network/virtualNetworks/subnets/join/action`, `Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action` and `Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action`.<br>            })<br>          }<br>        )<br>      ))<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_app_service_plan"></a> [app\_service\_plan](#input\_app\_service\_plan) | app service plan arguments definition. | <pre>object({<br>    name                                = optional(string)<br>    resource_groups_map_key             = optional(string, "default")<br>    os_type                             = optional(string, "Linux")<br>    sku_name                            = optional(string, "S1")<br>    app_service_environment_resource_id = optional(string)<br>    webapps = optional(map(object({<br>      name         = string<br>      app_settings = optional(map(string))<br>    })), {})<br>  })</pre> | `{}` | no |
| <a name="input_contacts"></a> [contacts](#input\_contacts) | A map of contacts for the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. | <pre>map(object({<br>    email = string<br>    name  = optional(string, null)<br>    phone = optional(string, null)<br>  }))</pre> | `{}` | no |
| <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry) | This variable controls whether or not telemetry is enabled for the module.<br>For more information see https://aka.ms/avm/telemetry.<br>If it is set to false, then no telemetry will be collected. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment such as dev,UAT or prod | `string` | `"dev"` | no |
| <a name="input_keyvault"></a> [keyvault](#input\_keyvault) | n/a | <pre>object({<br>    name                          = optional(string)<br>    resource_groups_map_key       = optional(string, "default")<br>    public_network_access_enabled = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resource group/resources is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace) | name of the log analytics workspce. | <pre>object({<br>    name                    = string<br>    resource_groups_map_key = optional(string, "default")<br>  })</pre> | n/a | yes |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | The network ACL configuration for the Key Vault.<br>If not specified then the Key Vault will be created with a firewall that blocks access.<br>Specify `null` to create the Key Vault with no firewall.<br><br>- `bypass` - (Optional) Should Azure Services bypass the ACL. Possible values are `AzureServices` and `None`. Defaults to `None`.<br>- `default_action` - (Optional) The default action when no rule matches. Possible values are `Allow` and `Deny`. Defaults to `Deny`.<br>- `ip_rules` - (Optional) A list of IP rules in CIDR format. Defaults to `[]`.<br>- `virtual_network_subnet_ids` - (Optional) When using with Service Endpoints, a list of subnet IDs to associate with the Key Vault. Defaults to `[]`. | <pre>object({<br>    bypass                     = optional(string, "None")<br>    default_action             = optional(string, "Deny")<br>    ip_rules                   = optional(list(string), [])<br>    virtual_network_subnet_ids = optional(list(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | Create network security groups and associated rules. | <pre>map(object({<br>    name                    = string<br>    resource_groups_map_key = optional(string, "network")<br>    rules = optional(map(object({<br>      nsg_rule_priority                   = number # (Required) NSG rule priority.<br>      nsg_rule_direction                  = string # (Required) NSG rule direction. Possible values are `Inbound` and `Outbound`.<br>      nsg_rule_access                     = string # (Required) NSG rule access. Possible values are `Allow` and `Deny`.<br>      nsg_rule_protocol                   = string # (Required) NSG rule protocol. Possible values are `Tcp`, `Udp`, `Icmp`, `Esp`, `Asterisk`.<br>      nsg_rule_source_port_range          = string # (Required) NSG rule source port range.<br>      nsg_rule_destination_port_range     = string # (Required) NSG rule destination port range.<br>      nsg_rule_source_address_prefix      = string # (Required) NSG rule source address prefix.<br>      nsg_rule_destination_address_prefix = string # (Required) NSG rule destination address prefix.<br>    })), {})<br>  }))</pre> | `{}` | no |
| <a name="input_postgresql_flexible_server"></a> [postgresql\_flexible\_server](#input\_postgresql\_flexible\_server) | n/a | <pre>object({<br>    name                     = string<br>    resource_groups_map_key  = optional(string, "default")<br>    delegated_vnet_map_key   = optional(string)<br>    delegated_subnet_name    = optional(string)<br>    private_dns_zone_map_key = optional(string)<br>    storage_tier             = optional(string, "P30")<br>    storage_mb               = optional(number, 32768)<br>    sku_name                 = optional(string, "GP_Standard_D4s_v3")<br>    zone                     = optional(number, 2)<br>    databases = optional(list(object({<br>      name      = string<br>      charset   = optional(string, "utf8")<br>      collation = optional(string, "en_US.utf8")<br>    })), [])<br>  })</pre> | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of project for which the infra will create. | `string` | `"onearc"` | no |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | map of object defines the details of the resource groups | <pre>map(object({<br>    name   = string<br>    region = optional(string)<br>  }))</pre> | <pre>{<br>  "default": {<br>    "name": "rg"<br>  },<br>  "network": {<br>    "name": "rg-network"<br>  },<br>  "privateDnsZones": {<br>    "name": "rg-dns"<br>  }<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->