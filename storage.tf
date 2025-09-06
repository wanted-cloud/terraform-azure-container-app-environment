resource "azurerm_container_app_environment_storage" "this" {
  for_each = { for storage in var.share_storages : storage["name"] => storage }

  name                         = each.value.name
  container_app_environment_id = azurerm_container_app_environment.example.id
  access_mode                  = each.value.access_mode
  account_name                 = each.value.account_name
  share_name                   = each.value.share_name
  access_key                   = each.value.access_key
  nfs_server_url               = each.value.nfs_server_url != "" ? each.value.nfs_server_url : format("%s.file.core.windows.net", each.value.name)

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