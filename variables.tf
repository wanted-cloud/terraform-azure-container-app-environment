variable "name" {
  description = "Name of the Azure Container App Environment."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group in which the Azure Container App Environment will be created."
  type        = string
}

variable "location" {
  description = "Location of the Azure Container App Environment."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "infrastructure_resource_group_name" {
  description = "Name of the infrastructure resource group."
  type        = string
  default     = ""
}

variable "infrastructure_subnet_id" {
  description = "ID of the infrastructure subnet."
  type        = string
  default     = ""
}

variable "internal_load_balancer_enabled" {
  description = "Enable internal load balancer."
  type        = bool
  default     = false
}

variable "zone_redundancy_enabled" {
  description = "Enable zone redundancy."
  type        = bool
  default     = false
}

variable "mutual_tls_enabled" {
  description = "Enable mutual TLS."
  type        = bool
  default     = false
}

variable "logs_destination" {
  description = "Logs destination for the Azure Container App Environment."
  type        = string
  default     = "azure-monitor"
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace."
  type        = string
  default     = ""
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string), [])
  })
  default = null
}

variable "workload_profiles" {
  description = "Workload profiles for the Azure Container App Environment."
  type = list(object({
    name                  = string
    workload_profile_type = string
    minimum_count         = number
    maximum_count         = number
  }))
  default = []
}

variable "certificates" {
  description = "Certificates for the Azure Container App Environment."
  type = list(object({
    name             = string
    certificate_path = string
    certificate_pass = string
  }))
  default = []

}

variable "domains" {
  description = "Custom domains for the Azure Container App Environment."
  type = list(object({
    dns_suffix              = string
    certificate_blob_base64 = string
    certificate_password    = string
  }))
  default = []
}

variable "share_storages" {
  description = "Storage configurations for the Azure Container App Environment."
  type = list(object({
    name           = string
    share_name     = string
    access_mode    = optional(string, "ReadWrite")
    account_name   = optional(string, "")
    access_key     = optional(string, "")
    nfs_server_url = optional(string, "")
  }))
  default = []
}

variable "dapr_components" {
  description = "Dapr components for the Azure Container App Environment."
  type = list(object({
    name                         = string
    container_app_environment_id = string
    component_type               = string
    version                      = string
    ignore_errors                = optional(bool, false)
    init_timeout                 = optional(string, "5s")
    scopes                       = optional(list(string), [])
    metadata = optional(list(object({
      name        = string
      secret_name = optional(string, "")
      value       = optional(string, "")
    })), [])
    secrets = optional(list(object({
      name  = string
      value = string
    })), [])
  }))
  default = []
}

variable "dapr_application_insights_connection_string" {
  description = "Application Insights connection string used by Dapr."
  type        = string
  default     = ""
}