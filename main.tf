/*
 * # wanted-cloud/terraform-azure-container-app-environment
 * 
 * Terraform building block managing Azure Container App Environment and its related resources.
 */

resource "azurerm_container_app_environment" "this" {
  name                           = var.name
  location                       = var.location != "" ? var.location : data.azurerm_resource_group.this.location
  resource_group_name            = data.azurerm_resource_group.this.name
  mutual_tls_enabled             = var.mutual_tls_enabled
  zone_redundancy_enabled        = var.zone_redundancy_enabled
  internal_load_balancer_enabled = var.internal_load_balancer_enabled

  infrastructure_subnet_id           = var.infrastructure_subnet_id != "" ? var.infrastructure_subnet_id : null
  infrastructure_resource_group_name = var.infrastructure_resource_group_name != "" ? var.infrastructure_resource_group_name : null

  logs_destination           = var.logs_destination != "" ? var.logs_destination : null
  log_analytics_workspace_id = var.log_analytics_workspace_id != "" ? var.log_analytics_workspace_id : null

  tags = var.tags

  dynamic "identity" {
    for_each = var.identity_type != "" ? [var.identity_type] : []
    content {
      type         = identity.value
      identity_ids = var.user_assigned_identity_ids
    }
  }

  dynamic "workload_profile" {
    for_each = { for profile in var.workload_profiles : profile["name"] => profile }
    content {
      name                  = workload_profile.value.name
      workload_profile_type = workload_profile.value.workload_profile_type
      minimum_count         = workload_profile.value.min_instances
      maximum_count         = workload_profile.value.max_instances
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