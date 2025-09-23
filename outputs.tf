output "container_app_environment" {
  value = azurerm_container_app_environment.this
}

output "container_app_environment_certificates" {
  value = azurerm_container_app_environment_certificate.this
}

output "container_app_environment_dapr_components" {
  value = azurerm_container_app_environment_dapr_component.this
}

output "container_app_environment_custom_domains" {
  value = azurerm_container_app_environment_custom_domain.this
}

output "container_app_environment_storages" {
  value = azurerm_container_app_environment_storage.this
}