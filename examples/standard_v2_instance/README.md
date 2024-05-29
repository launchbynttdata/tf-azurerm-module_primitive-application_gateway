# Standard Application Gateway instance

This example will provision a Application Gateway instance which is `Standard V2`. It will have a public IP as well as a static IP address in
a Vnet. Resources within the same VNet can access this App Gateway using the private IP address and the App Gateway can access other backends
deployed in the same VNet privately.

To access backends in other Vnet or other services accessing this instance privately, one needs to create a Private Endpoint.

Although a public IP is automatically assigned to this App Gateway instance, user can still access it private only by only creating a
listener that listens on the private IP. The public IP doesn't have a listener attached to it.

At this moment, `private only` Application Gateway is in `Preview mode`.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | <= 1.5.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.77 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | git::https://github.com/launchbynttdata/tf-launch-module_library-resource_name.git | 1.0.1 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-resource_group.git | 1.0.0 |
| <a name="module_public_ip"></a> [public\_ip](#module\_public\_ip) | git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-public_ip | 1.0.0 |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-virtual_network.git | 2.0.0 |
| <a name="module_application_gateway"></a> [application\_gateway](#module\_application\_gateway) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_product_family"></a> [product\_family](#input\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"dso"` | no |
| <a name="input_product_service"></a> [product\_service](#input\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"app"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region in which the infra needs to be provisioned | `string` | `"eastus"` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object(<br>    {<br>      name       = string<br>      max_length = optional(number, 60)<br>    }<br>  ))</pre> | <pre>{<br>  "app_gateway": {<br>    "max_length": 60,<br>    "name": "appgw"<br>  },<br>  "nsg": {<br>    "max_length": 60,<br>    "name": "nsg"<br>  },<br>  "public_ip": {<br>    "max_length": 60,<br>    "name": "pip"<br>  },<br>  "resource_group": {<br>    "max_length": 60,<br>    "name": "rg"<br>  },<br>  "vnet": {<br>    "max_length": 24,<br>    "name": "vnet"<br>  }<br>}</pre> | no |
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | Address space of the Vnet | `list(string)` | <pre>[<br>  "10.60.0.0/16"<br>]</pre> | no |
| <a name="input_subnet_names"></a> [subnet\_names](#input\_subnet\_names) | Name of the subnets to be created | `list(string)` | <pre>[<br>  "app-gtw-subnet"<br>]</pre> | no |
| <a name="input_subnet_prefixes"></a> [subnet\_prefixes](#input\_subnet\_prefixes) | The CIDR blocks of the subnets whose names are specified in `subnet_names` | `list(string)` | <pre>[<br>  "10.60.0.0/24"<br>]</pre> | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The SKU of the Application Gateway. Possible values are: Standard\_v2 or WAF\_v2. | `string` | `"Standard_v2"` | no |
| <a name="input_sku_capacity"></a> [sku\_capacity](#input\_sku\_capacity) | The Capacity of the SKU to use for this Application Gateway - which must be between 1 and 10, optional if autoscale\_configuration is set | `number` | `1` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | A collection of availability zones to spread the Application Gateway over. This option is only supported for v2 SKUs | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |
| <a name="input_gateway_ip_configuration_name"></a> [gateway\_ip\_configuration\_name](#input\_gateway\_ip\_configuration\_name) | Name of the gateway IP configuration. | `string` | n/a | yes |
| <a name="input_frontend_ip_configuration_name"></a> [frontend\_ip\_configuration\_name](#input\_frontend\_ip\_configuration\_name) | Name of the frontend IP configuration. | `string` | n/a | yes |
| <a name="input_appgw_private"></a> [appgw\_private](#input\_appgw\_private) | Boolean variable to create a private Application Gateway. When `true`, the default http listener will listen on private IP instead of the public IP. | `bool` | `true` | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | The private IP address of the Application Gateway. Must be within the range of the subnet | `string` | `"10.60.0.4"` | no |
| <a name="input_frontend_private_ip_configuration_name"></a> [frontend\_private\_ip\_configuration\_name](#input\_frontend\_private\_ip\_configuration\_name) | Name of the frontend private IP configuration. | `string` | `null` | no |
| <a name="input_frontend_port_settings"></a> [frontend\_port\_settings](#input\_frontend\_port\_settings) | Frontend port settings. Each port setting contains the name and the port for the frontend port. | <pre>list(object({<br>    name = string<br>    port = number<br>  }))</pre> | `[]` | no |
| <a name="input_appgw_backend_pools"></a> [appgw\_backend\_pools](#input\_appgw\_backend\_pools) | List of objects with backend pool configurations. | <pre>list(object({<br>    name         = string<br>    fqdns        = optional(list(string))<br>    ip_addresses = optional(list(string))<br>  }))</pre> | n/a | yes |
| <a name="input_appgw_backend_http_settings"></a> [appgw\_backend\_http\_settings](#input\_appgw\_backend\_http\_settings) | List of objects including backend http settings configurations. | <pre>list(object({<br>    name     = string<br>    port     = optional(number, 443)<br>    protocol = optional(string, "Https")<br><br>    path       = optional(string)<br>    probe_name = optional(string)<br><br>    cookie_based_affinity               = optional(string, "Disabled")<br>    affinity_cookie_name                = optional(string, "ApplicationGatewayAffinity")<br>    request_timeout                     = optional(number, 20)<br>    host_name                           = optional(string)<br>    pick_host_name_from_backend_address = optional(bool, true)<br>    trusted_root_certificate_names      = optional(list(string), [])<br>    authentication_certificate          = optional(string)<br><br>    connection_draining_timeout_sec = optional(number)<br>  }))</pre> | n/a | yes |
| <a name="input_appgw_http_listeners"></a> [appgw\_http\_listeners](#input\_appgw\_http\_listeners) | List of objects with HTTP listeners configurations and custom error configurations. | <pre>list(object({<br>    name = string<br><br>    frontend_ip_configuration_name = optional(string)<br>    frontend_port_name             = optional(string)<br>    host_name                      = optional(string)<br>    host_names                     = optional(list(string))<br>    protocol                       = optional(string, "Https")<br>    require_sni                    = optional(bool, false)<br>    ssl_certificate_name           = optional(string)<br>    ssl_profile_name               = optional(string)<br>    firewall_policy_id             = optional(string)<br><br>    custom_error_configuration = optional(list(object({<br>      status_code           = string<br>      custom_error_page_url = string<br>    })), [])<br>  }))</pre> | n/a | yes |
| <a name="input_appgw_routings"></a> [appgw\_routings](#input\_appgw\_routings) | List of objects with request routing rules configurations. With AzureRM v3+ provider, `priority` attribute becomes mandatory. | <pre>list(object({<br>    name                        = string<br>    rule_type                   = optional(string, "Basic")<br>    http_listener_name          = optional(string)<br>    backend_address_pool_name   = optional(string)<br>    backend_http_settings_name  = optional(string)<br>    url_path_map_name           = optional(string)<br>    redirect_configuration_name = optional(string)<br>    rewrite_rule_set_name       = optional(string)<br>    priority                    = optional(number)<br>  }))</pre> | n/a | yes |
| <a name="input_appgw_probes"></a> [appgw\_probes](#input\_appgw\_probes) | List of objects with probes configurations. | <pre>list(object({<br>    name     = string<br>    host     = optional(string)<br>    port     = optional(number, null)<br>    interval = optional(number, 30)<br>    path     = optional(string, "/")<br>    protocol = optional(string, "Https")<br>    timeout  = optional(number, 30)<br><br>    unhealthy_threshold                       = optional(number, 3)<br>    pick_host_name_from_backend_http_settings = optional(bool, false)<br>    minimum_servers                           = optional(number, 0)<br><br>    match = optional(object({<br>      body        = optional(string, "")<br>      status_code = optional(list(string), ["200-399"])<br>    }), {})<br>  }))</pre> | `[]` | no |
| <a name="input_ssl_certificates_configs"></a> [ssl\_certificates\_configs](#input\_ssl\_certificates\_configs) | List of objects with SSL certificates configurations.<br>The path to a base-64 encoded certificate is expected in the 'data' attribute:<pre>data = filebase64("./file_path")</pre> | <pre>list(object({<br>    name                = string<br>    data                = optional(string)<br>    password            = optional(string)<br>    key_vault_secret_id = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_authentication_certificates_configs"></a> [authentication\_certificates\_configs](#input\_authentication\_certificates\_configs) | List of objects with authentication certificates configurations.<br>The path to a base-64 encoded certificate is expected in the 'data' attribute:<pre>data = filebase64("./file_path")</pre> | <pre>list(object({<br>    name = string<br>    data = string<br>  }))</pre> | `[]` | no |
| <a name="input_trusted_client_certificates_configs"></a> [trusted\_client\_certificates\_configs](#input\_trusted\_client\_certificates\_configs) | List of objects with trusted client certificates configurations.<br>The path to a base-64 encoded certificate is expected in the 'data' attribute:<pre>data = filebase64("./file_path")</pre> | <pre>list(object({<br>    name = string<br>    data = string<br>  }))</pre> | `[]` | no |
| <a name="input_trusted_root_certificate_configs"></a> [trusted\_root\_certificate\_configs](#input\_trusted\_root\_certificate\_configs) | List of trusted root certificates. `file_path` is checked first, using `data` (base64 cert content) if null. This parameter is required if you are not using a trusted certificate authority (eg. selfsigned certificate). | <pre>list(object({<br>    name                = string<br>    data                = optional(string)<br>    file_path           = optional(string)<br>    key_vault_secret_id = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | User assigned identity id assigned to this resource. | `string` | `null` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Whether to enable http2 or not | `bool` | `true` | no |
| <a name="input_autoscaling_parameters"></a> [autoscaling\_parameters](#input\_autoscaling\_parameters) | Map containing autoscaling parameters. Must contain at least min\_capacity | <pre>object({<br>    min_capacity = number<br>    max_capacity = optional(number, 5)<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_gateway_id"></a> [app\_gateway\_id](#output\_app\_gateway\_id) | n/a |
| <a name="output_app_gateway_name"></a> [app\_gateway\_name](#output\_app\_gateway\_name) | n/a |
| <a name="output_frontend_ip_configuration"></a> [frontend\_ip\_configuration](#output\_frontend\_ip\_configuration) | n/a |
| <a name="output_frontend_port"></a> [frontend\_port](#output\_frontend\_port) | n/a |
| <a name="output_backend_address_pool"></a> [backend\_address\_pool](#output\_backend\_address\_pool) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
