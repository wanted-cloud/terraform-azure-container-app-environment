resource "azurerm_resource_group" "this" {
  name     = "rg-container-app-env-example"
  location = "West Europe"
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "law-example"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  depends_on = [azurerm_resource_group.this]
}

module "container_app_environment" {
  depends_on = [azurerm_resource_group.this, azurerm_log_analytics_workspace.this]
  source = "../.."

  name                       = "cae-example"
  resource_group_name        = azurerm_resource_group.this.name
  location                  = azurerm_resource_group.this.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  tags = {
    Environment = "Basic"
    ManagedBy   = "Terraform"
  }
}