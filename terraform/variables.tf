variable "location" {
  type        = string
  description = <<DESCRIPTION
  The location/region where the resource group/resources is created. Changing this forces a new resource to be created.
  DESCRIPTION
}

variable "project_name" {
  type        = string
  default     = "POC"
  description = "Name of project for which the infra will create."
}

variable "environment" {
  type        = string
  description = "Name of the environment such as dev,UAT or prod"
  default     = "dev"
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

variable "app_service_plan" {
  type = object({
    name                    = string
    resource_groups_map_key = optional(string, "default")
    webapps = optional(map(object({
      name         = string
      kind         = optional(string, "webapp")
      os_type      = optional(string, "Linux")
      app_settings = optional(map(string))
      virtual_network_subnet_key = optional(string)
    })), {})
  })
}

variable "subnets" {
  type = map(object({
    vnet_name               = string
    subnet_name             = string
    resource_groups_map_key = optional(string, "network")
  }))
}

variable "postgresql_flexible_server" {
  type = object({
    name                     = string
    resource_groups_map_key  = optional(string, "default")
    delegated_subnet_map_key = string
    private_dns_zone_map_key = string
    storage_tier             = optional(string, "P30")
    storage_mb               = optional(number, 32768)
    sku_name                 = optional(string, "GP_Standard_D4s_v3")
    zone                     = optional(number,2)
    databases = optional(list(object({
      name      = string
      charset   = optional(string, "utf8")
      collation = optional(string, "en_US.utf8")
    })), [])
  })

}

variable "keyvault" {
  type = object({
    name                    = optional(string)
    resource_groups_map_key = optional(string, "default")
  })
  default = {}
}

