/*
 * # wanted-cloud/terraform-azure-container-app-environment
 * 
 * Terraform building block managing Azure Container App Environment and its related resources.
 */

resource "azurerm_container_app_environment" "this" {
  name                = var.name
  location            = var.location != "" ? var.location : data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  mutual_tls_enabled  = var.mutual_tls_enabled

  infrastructure_subnet_id           = var.infrastructure_subnet_id != "" ? var.infrastructure_subnet_id : null
  infrastructure_resource_group_name = var.infrastructure_resource_group_name != "" ? var.infrastructure_resource_group_name : null
  zone_redundancy_enabled            = var.infrastructure_subnet_id != "" && var.zone_redundancy_enabled ? true : null
  internal_load_balancer_enabled     = var.infrastructure_subnet_id != "" && var.internal_load_balancer_enabled ? true : null

  dapr_application_insights_connection_string = var.dapr_application_insights_connection_string != "" ? var.dapr_application_insights_connection_string : null
  log_analytics_workspace_id                  = var.log_analytics_workspace_id != "" ? var.log_analytics_workspace_id : null

  tags = merge(local.metadata.tags, var.tags)

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "workload_profile" {
    for_each = { for profile in var.workload_profiles : profile["name"] => profile }
    content {
      name                  = workload_profile.value.name
      workload_profile_type = workload_profile.value.workload_profile_type
      minimum_count         = workload_profile.value.minimum_count
      maximum_count         = workload_profile.value.maximum_count
    }
  }

  timeouts {
    create = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment"]["create"],
      local.metadata.resource_timeouts["default"]["create"]
    )
    read = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment"]["read"],
      local.metadata.resource_timeouts["default"]["read"]
    )
    update = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment"]["update"],
      local.metadata.resource_timeouts["default"]["update"]
    )
    delete = try(
      local.metadata.resource_timeouts["azurerm_container_app_environment"]["delete"],
      local.metadata.resource_timeouts["default"]["delete"]
    )
  }
}