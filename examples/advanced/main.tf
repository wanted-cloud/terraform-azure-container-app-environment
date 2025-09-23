resource "azurerm_resource_group" "this" {
  name     = "rg-container-app-env-example"
  location = "North Europe"
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "law-advanced-example"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 90

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-example"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_subnet" "container_apps" {
  name                 = "subnet-container-apps"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/23"]

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

module "container_app_environment" {
  depends_on = [azurerm_resource_group.this, azurerm_log_analytics_workspace.this, azurerm_subnet.container_apps]
  source = "../.."

  name                       = "cae-example"
  resource_group_name        = azurerm_resource_group.this.name
  location                  = azurerm_resource_group.this.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  infrastructure_subnet_id           = azurerm_subnet.container_apps.id
  infrastructure_resource_group_name = "rg-container-app-env-example-infra"
  internal_load_balancer_enabled     = true
  zone_redundancy_enabled           = false

  mutual_tls_enabled = true

  identity = {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }

  workload_profiles = [
    {
      name                  = "Consumption"
      workload_profile_type = "Consumption"
      minimum_count         = 0
      maximum_count         = 0
    }
  ]

  tags = {
    Environment = "Advanced"
    ManagedBy   = "Terraform"
  }
}