<!-- BEGIN_TF_DOCS -->
# wanted-cloud/terraform-azure-container-app-environment

Terraform building block managing Azure Container App Environment and its related resources.

## Table of contents

- [Requirements](#requirements)
- [Providers](#providers)
- [Variables](#inputs)
- [Outputs](#outputs)
- [Resources](#resources)
- [Usage](#usage)
- [Contributing](#contributing)

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.11)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>=4.20.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>=4.20.0)

## Required Inputs

The following input variables are required:

### <a name="input_name"></a> [name](#input\_name)

Description: Name of the Azure Container App Environment.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Name of the resource group in which the Azure Container App Environment will be created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type)

Description: Type of identity to use for the Azure service plan.

Type: `string`

Default: `""`

### <a name="input_infrastructure_resource_group_name"></a> [infrastructure\_resource\_group\_name](#input\_infrastructure\_resource\_group\_name)

Description: Name of the infrastructure resource group.

Type: `string`

Default: `""`

### <a name="input_infrastructure_subnet_id"></a> [infrastructure\_subnet\_id](#input\_infrastructure\_subnet\_id)

Description: ID of the infrastructure subnet.

Type: `string`

Default: `""`

### <a name="input_internal_load_balancer_enabled"></a> [internal\_load\_balancer\_enabled](#input\_internal\_load\_balancer\_enabled)

Description: Enable internal load balancer.

Type: `bool`

Default: `false`

### <a name="input_location"></a> [location](#input\_location)

Description: Location of the Azure Container App Environment.

Type: `string`

Default: `""`

### <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id)

Description: ID of the Log Analytics workspace.

Type: `string`

Default: `""`

### <a name="input_logs_destination"></a> [logs\_destination](#input\_logs\_destination)

Description: Logs destination for the Azure Container App Environment.

Type: `string`

Default: `"azure-monitor"`

### <a name="input_metadata"></a> [metadata](#input\_metadata)

Description: Metadata definitions for the module, this is optional construct allowing override of the module defaults defintions of validation expressions, error messages, resource timeouts and default tags.

Type:

```hcl
object({
    resource_timeouts = optional(
      map(
        object({
          create = optional(string, "30m")
          read   = optional(string, "5m")
          update = optional(string, "30m")
          delete = optional(string, "30m")
        })
      ), {}
    )
    tags                     = optional(map(string), {})
    validator_error_messages = optional(map(string), {})
    validator_expressions    = optional(map(string), {})
  })
```

Default: `{}`

### <a name="input_mutual_tls_enabled"></a> [mutual\_tls\_enabled](#input\_mutual\_tls\_enabled)

Description: Enable mutual TLS.

Type: `bool`

Default: `false`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: A map of tags to assign to the resource.

Type: `map(string)`

Default: `{}`

### <a name="input_user_assigned_identity_ids"></a> [user\_assigned\_identity\_ids](#input\_user\_assigned\_identity\_ids)

Description: List of user assigned identity IDs for the Azure service plan.

Type: `list(string)`

Default: `[]`

### <a name="input_workload_profiles"></a> [workload\_profiles](#input\_workload\_profiles)

Description: Workload profiles for the Azure Container App Environment.

Type:

```hcl
list(object({
    name                  = string
    workload_profile_type = string
    min_instances         = number
    max_instances         = number
  }))
```

Default: `[]`

### <a name="input_zone_redundancy_enabled"></a> [zone\_redundancy\_enabled](#input\_zone\_redundancy\_enabled)

Description: Enable zone redundancy.

Type: `bool`

Default: `false`

## Outputs

No outputs.

## Resources

The following resources are used by this module:

- [azurerm_container_app_environment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) (resource)
- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)

## Usage

> For more detailed examples navigate to `examples` folder of this repository.

Module was also published via Terraform Registry and can be used as a module from the registry.

```hcl
module "example" {
  source  = "wanted-cloud/..."
  version = "x.y.z"
}
```

### Basic usage example

The minimal usage for the module is as follows:

```hcl
module "template" {
    source = "../.."
}
```
## Contributing

_Contributions are welcomed and must follow [Code of Conduct](https://github.com/wanted-cloud/.github?tab=coc-ov-file) and common [Contributions guidelines](https://github.com/wanted-cloud/.github/blob/main/docs/CONTRIBUTING.md)._

> If you'd like to report security issue please follow [security guidelines](https://github.com/wanted-cloud/.github?tab=security-ov-file).
---
<sup><sub>_2025 &copy; All rights reserved - WANTED.solutions s.r.o._</sub></sup>
<!-- END_TF_DOCS -->