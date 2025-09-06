resource "azurerm_container_app_environment_certificate" "this" {
  for_each = { for cert in var.certificates : cert["name"] => cert }

  name                         = each.value.name
  container_app_environment_id = azurerm_container_app_environment.this.id
  certificate_blob_base64      = filebase64(each.value.certificate_path)
  certificate_password         = each.value.certificate_pass

  timeouts {
    create = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_certificate"]["create"],
      local.metadata.resource_timeouts["default"]["create"]
    )
    read = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_certificate"]["read"],
      local.metadata.resource_timeouts["default"]["read"]
    )
    update = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_certificate"]["update"],
      local.metadata.resource_timeouts["default"]["update"]
    )
    delete = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_certificate"]["delete"],
      local.metadata.resource_timeouts["default"]["delete"]
    )
  }
}