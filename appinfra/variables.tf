variable "project_name" {
  type        = string
  default     = "onearc"
  description = "Name of project for which the infra will create."
}

variable "environment" {
  type        = string
  description = "Name of the environment such as dev,UAT or prod"
  default     = "dev"
}

variable "location" {
  type        = string
  description = <<DESCRIPTION
  The location/region where the resource group/resources is created. Changing this forces a new resource to be created.
  DESCRIPTION
}

variable "enable_telemetry" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetry.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "resource_groups" {
  type = map(object({
    name   = string
    region = optional(string)
  }))
  description = "map of object defines the details of the resource groups"
  default = {
    "network" = {
      name = "rg-network"
    }
    "default" = {
      name = "rg"
    }
    "privateDnsZones" = {
      name = "rg-dns"
    }
  }
}

variable "log_analytics_workspace" {
  type = object({
    name                    = string
    resource_groups_map_key = optional(string, "default")
  })
  description = "name of the log analytics workspce."
}

variable "VirtualNetworks" {
  type = map(object({
    vnet_name                     = string
    resource_groups_map_key       = optional(string, "network")
    virtual_network_address_space = list(string)
    subnets = map(object({
      address_prefixes                          = list(string)
      private_endpoint_network_policies_enabled = optional(bool, false)
      service_endpoints                         = optional(set(string))
      network_security_groups_map_key           = optional(string)
      delegations = optional(list(
        object(
          {
            name = string # (Required) A name for this delegation.
            service_delegation = object({
              name    = string                 # (Required) The name of service to delegate to. Possible values include `Microsoft.ApiManagement/service`, `Microsoft.AzureCosmosDB/clusters`, `Microsoft.BareMetal/AzureVMware`, `Microsoft.BareMetal/CrayServers`, `Microsoft.Batch/batchAccounts`, `Microsoft.ContainerInstance/containerGroups`, `Microsoft.ContainerService/managedClusters`, `Microsoft.Databricks/workspaces`, `Microsoft.DBforMySQL/flexibleServers`, `Microsoft.DBforMySQL/serversv2`, `Microsoft.DBforPostgreSQL/flexibleServers`, `Microsoft.DBforPostgreSQL/serversv2`, `Microsoft.DBforPostgreSQL/singleServers`, `Microsoft.HardwareSecurityModules/dedicatedHSMs`, `Microsoft.Kusto/clusters`, `Microsoft.Logic/integrationServiceEnvironments`, `Microsoft.MachineLearningServices/workspaces`, `Microsoft.Netapp/volumes`, `Microsoft.Network/managedResolvers`, `Microsoft.Orbital/orbitalGateways`, `Microsoft.PowerPlatform/vnetaccesslinks`, `Microsoft.ServiceFabricMesh/networks`, `Microsoft.Sql/managedInstances`, `Microsoft.Sql/servers`, `Microsoft.StoragePool/diskPools`, `Microsoft.StreamAnalytics/streamingJobs`, `Microsoft.Synapse/workspaces`, `Microsoft.Web/hostingEnvironments`, `Microsoft.Web/serverFarms`, `NGINX.NGINXPLUS/nginxDeployments` and `PaloAltoNetworks.Cloudngfw/firewalls`.
              actions = optional(list(string)) # (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values include `Microsoft.Network/networkinterfaces/*`, `Microsoft.Network/virtualNetworks/subnets/action`, `Microsoft.Network/virtualNetworks/subnets/join/action`, `Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action` and `Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action`.
            })
          }
        )
      ))
    }))
  }))
  description = "Create virtual network and subnets. In subnets map of object key is the name of the subnets."
  default     = {}
}

variable "network_security_groups" {
  type = map(object({
    name                    = string
    resource_groups_map_key = optional(string, "network")
    rules = optional(map(object({
      nsg_rule_priority                   = number # (Required) NSG rule priority.
      nsg_rule_direction                  = string # (Required) NSG rule direction. Possible values are `Inbound` and `Outbound`.
      nsg_rule_access                     = string # (Required) NSG rule access. Possible values are `Allow` and `Deny`.
      nsg_rule_protocol                   = string # (Required) NSG rule protocol. Possible values are `Tcp`, `Udp`, `Icmp`, `Esp`, `Asterisk`.
      nsg_rule_source_port_range          = string # (Required) NSG rule source port range.
      nsg_rule_destination_port_range     = string # (Required) NSG rule destination port range.
      nsg_rule_source_address_prefix      = string # (Required) NSG rule source address prefix.
      nsg_rule_destination_address_prefix = string # (Required) NSG rule destination address prefix.
    })), {})
  }))
  description = "Create network security groups and associated rules."
  default     = {}
}

variable "keyvault" {
  type = object({
    name                          = optional(string)
    resource_groups_map_key       = optional(string, "default")
    public_network_access_enabled = optional(bool, true)
  })
  default = {}
}

variable "contacts" {
  type = map(object({
    email = string
    name  = optional(string, null)
    phone = optional(string, null)
  }))
  default     = {}
  description = "A map of contacts for the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time."
}

variable "network_acls" {
  type = object({
    bypass                     = optional(string, "None")
    default_action             = optional(string, "Deny")
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default     = {}
  description = <<DESCRIPTION
The network ACL configuration for the Key Vault.
If not specified then the Key Vault will be created with a firewall that blocks access.
Specify `null` to create the Key Vault with no firewall.

- `bypass` - (Optional) Should Azure Services bypass the ACL. Possible values are `AzureServices` and `None`. Defaults to `None`.
- `default_action` - (Optional) The default action when no rule matches. Possible values are `Allow` and `Deny`. Defaults to `Deny`.
- `ip_rules` - (Optional) A list of IP rules in CIDR format. Defaults to `[]`.
- `virtual_network_subnet_ids` - (Optional) When using with Service Endpoints, a list of subnet IDs to associate with the Key Vault. Defaults to `[]`.
DESCRIPTION

  validation {
    condition     = var.network_acls == null ? true : contains(["AzureServices", "None"], var.network_acls.bypass)
    error_message = "The bypass value must be either `AzureServices` or `None`."
  }
  validation {
    condition     = var.network_acls == null ? true : contains(["Allow", "Deny"], var.network_acls.default_action)
    error_message = "The default_action value must be either `Allow` or `Deny`."
  }
}

variable "app_service_plan" {
  type = object({
    name                                = optional(string)
    resource_groups_map_key             = optional(string, "default")
    os_type                             = optional(string, "Linux")
    sku_name                            = optional(string, "B1")
    app_service_environment_resource_id = optional(string)
    webapps = optional(map(object({
      name         = string
      app_settings = optional(map(string))
    })), {})
  })
  description = "app service plan arguments definition."
  default     = {}
}

variable "postgresql_flexible_server" {
  type = object({
    name                     = string
    resource_groups_map_key  = optional(string, "default")
    delegated_vnet_map_key   = optional(string)
    delegated_subnet_name    = optional(string)
    private_dns_zone_map_key = optional(string)
    storage_tier             = optional(string, "P30")
    storage_mb               = optional(number, 32768)
    sku_name                 = optional(string, "GP_Standard_D4s_v3")
    zone                     = optional(number)
    databases = optional(list(object({
      name      = string
      charset   = optional(string, "utf8")
      collation = optional(string, "en_US.utf8")
    })), [])
  })

}