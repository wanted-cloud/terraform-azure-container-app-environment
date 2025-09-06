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

variable "identity_type" {
  description = "Type of identity to use for the Azure service plan."
  type        = string
  default     = ""
}

variable "user_assigned_identity_ids" {
  description = "List of user assigned identity IDs for the Azure service plan."
  type        = list(string)
  default     = []
}

variable "workload_profiles" {
  description = "Workload profiles for the Azure Container App Environment."
  type = list(object({
    name                  = string
    workload_profile_type = string
    min_instances         = number
    max_instances         = number
  }))
  default = []
}