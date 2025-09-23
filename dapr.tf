resource "azurerm_container_app_environment_dapr_component" "this" {
  for_each = { for comp in var.dapr_components : comp["name"] => comp }

  name                         = each.value.name
  container_app_environment_id = azurerm_container_app_environment.this.id
  component_type               = each.value.component_type
  version                      = each.value.version
  ignore_errors                = each.value.ignore_errors
  init_timeout                 = each.value.init_timeout
  scopes                       = each.value.scopes

  dynamic "metadata" {
    for_each = each.value.metadata
    content {
      name        = metadata.value.name
      secret_name = metadata.value.secret_name
      value       = metadata.value.value
    }
  }

  dynamic "secret" {
    for_each = each.value.secrets
    content {
      name  = secret.value.name
      value = secret.value.value
    }
  }

  timeouts {
    create = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_dapr_component"]["create"],
      local.metadata.resource_timeouts["default"]["create"]
    )
    read = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_dapr_component"]["read"],
      local.metadata.resource_timeouts["default"]["read"]
    )
    update = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_dapr_component"]["update"],
      local.metadata.resource_timeouts["default"]["update"]
    )
    delete = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment_dapr_component"]["delete"],
      local.metadata.resource_timeouts["default"]["delete"]
    )
  }

}