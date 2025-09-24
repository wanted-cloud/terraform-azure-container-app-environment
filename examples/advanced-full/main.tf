resource "azurerm_resource_group" "this" {
  name     = "rg-container-app-env-example"
  location = "East US 2"
}
 
resource "azurerm_log_analytics_workspace" "this" {
  name                = "law-example"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 180
  daily_quota_gb      = 10

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_application_insights" "this" {
  name                = "ai-example"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.this.id

  depends_on = [azurerm_log_analytics_workspace.this]
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-example"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_subnet" "container_apps" {
  name                 = "subnet-container-apps"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["192.168.1.0/21"]

  delegation {
    name = "Microsoft.App.environments"
    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }

  depends_on = [azurerm_virtual_network.this]
}

resource "azurerm_user_assigned_identity" "this" {
  location            = azurerm_resource_group.this.location
  name                = "uai-example"
  resource_group_name = azurerm_resource_group.this.name

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_storage_account" "this" {
  name                     = "stexample"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_storage_share" "this" {
  name                 = "share"
  storage_account_name = azurerm_storage_account.this.name
  quota                = 10

  depends_on = [azurerm_storage_account.this]
}

module "container_app_environment" {
  depends_on = [
    azurerm_resource_group.this, 
    azurerm_log_analytics_workspace.this, 
    azurerm_subnet.container_apps,
    azurerm_application_insights.this
  ]
  source = "../.."

  name                       = "cae-example"
  resource_group_name        = azurerm_resource_group.this.name
  location                  = azurerm_resource_group.this.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  infrastructure_subnet_id           = azurerm_subnet.container_apps.id
  infrastructure_resource_group_name = "rg-container-app-env-example-infra"
  internal_load_balancer_enabled     = true
  zone_redundancy_enabled           = true

  mutual_tls_enabled = true
  dapr_application_insights_connection_string = azurerm_application_insights.this.connection_string

  identity = {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }

  workload_profiles = [
    {
      name                  = "Consumption"
      workload_profile_type = "Consumption"
      minimum_count         = 0
      maximum_count         = 0
    },
    {
      name                  = "D4"
      workload_profile_type = "D4"
      minimum_count         = 1
      maximum_count         = 5
    },
    {
      name                  = "E4"
      workload_profile_type = "E4"
      minimum_count         = 0
      maximum_count         = 3
    }
  ]

  share_storages = [
    {
      name         = "shared-storage"
      share_name   = azurerm_storage_share.this.name
      access_mode  = "ReadWrite"
      account_name = azurerm_storage_account.this.name
      access_key   = azurerm_storage_account.this.primary_access_key
    }
  ]

  dapr_components = [
    {
      name                         = "statestore"
      container_app_environment_id = ""
      component_type               = "state.azure.blobstorage"
      version                      = "v1"
      scopes                       = ["my-container-app"]
      
      metadata = [
        {
          name  = "accountName"
          value = azurerm_storage_account.this.name
        },
        {
          name        = "accountKey"
          secret_name = "storage-key"
        }
      ]
      
      secrets = [
        {
          name  = "storage-key"
          value = azurerm_storage_account.this.primary_access_key
        }
      ]
    }
  ]

  tags = {
    Environment          = "AdvancedFull"
    ManagedBy            = "Terraform"
    Owner                = "DevOps-Team"
  }
}