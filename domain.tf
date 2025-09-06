resource "azurerm_container_app_environment_custom_domain" "this" {
  for_each = { for domain in var.domains : domain["dns_suffix"] => domain }

  container_app_environment_id = azurerm_container_app_environment.this.id
  certificate_blob_base64      = each.value.certificate_blob_base64
  certificate_password         = each.value.certificate_password
  dns_suffix                   = each.value.dns_suffix

  timeouts {
    create = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_custom_domain"]["create"],
      local.metadata.resource_timeouts["default"]["create"]
    )
    read = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_custom_domain"]["read"],
      local.metadata.resource_timeouts["default"]["read"]
    )
    update = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_custom_domain"]["update"],
      local.metadata.resource_timeouts["default"]["update"]
    )
    delete = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_custom_domain"]["delete"],
      local.metadata.resource_timeouts["default"]["delete"]
    )
  }
}