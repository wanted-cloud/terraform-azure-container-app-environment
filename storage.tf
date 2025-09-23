resource "azurerm_container_app_environment_storage" "this" {
  for_each = { for storage in var.share_storages : storage["name"] => storage }

  name                         = each.value.name
  container_app_environment_id = azurerm_container_app_environment.this.id
  access_mode                  = each.value.access_mode
  share_name                   = each.value.share_name
  
  account_name = each.value.nfs_server_url == "" ? each.value.account_name : null
  access_key   = each.value.nfs_server_url == "" ? each.value.access_key : null
  nfs_server_url = each.value.nfs_server_url != "" ? each.value.nfs_server_url : null

  timeouts {
    create = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_storage"]["create"],
      local.metadata.resource_timeouts["default"]["create"]
    )
    read = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_storage"]["read"],
      local.metadata.resource_timeouts["default"]["read"]
    )
    update = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_storage"]["update"],
      local.metadata.resource_timeouts["default"]["update"]
    )
    delete = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_storage"]["delete"],
      local.metadata.resource_timeouts["default"]["delete"]
    )
  }
}