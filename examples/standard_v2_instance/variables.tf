// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
variable "product_family" {
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  type        = string
  default     = "dso"
}

variable "product_service" {
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  type        = string
  default     = "app"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "region" {
  description = "AWS Region in which the infra needs to be provisioned"
  type        = string
  default     = "eastus"
}

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object(
    {
      name       = string
      max_length = optional(number, 60)
    }
  ))
  default = {
    app_gateway = {
      name       = "appgw"
      max_length = 60
    }
    public_ip = {
      name       = "pip"
      max_length = 60
    }
    resource_group = {
      name       = "rg"
      max_length = 60
    }
    nsg = {
      name       = "nsg"
      max_length = 60
    }
    vnet = {
      name       = "vnet"
      max_length = 24
    }
  }
}

# VNet related variables
variable "address_space" {
  description = "Address space of the Vnet"
  type        = list(string)
  default     = ["10.60.0.0/16"]
}

variable "subnet_names" {
  description = "Name of the subnets to be created"
  type        = list(string)
  default     = ["app-gtw-subnet"]
}

variable "subnet_prefixes" {
  description = "The CIDR blocks of the subnets whose names are specified in `subnet_names`"
  type        = list(string)
  default     = ["10.60.0.0/24"]
}

# Application Gateway related variables

variable "sku" {
  type        = string
  description = <<EOT
    The SKU of the Application Gateway. Possible values are: Standard_v2 or WAF_v2.
  EOT
  default     = "Standard_v2"
}

variable "sku_capacity" {
  description = "The Capacity of the SKU to use for this Application Gateway - which must be between 1 and 10, optional if autoscale_configuration is set"
  type        = number
  default     = 1
}

variable "zones" {
  description = "A collection of availability zones to spread the Application Gateway over. This option is only supported for v2 SKUs"
  type        = list(number)
  default     = [1, 2, 3]
}

variable "gateway_ip_configuration_name" {
  description = "Name of the gateway IP configuration."
  type        = string
}

variable "frontend_ip_configuration_name" {
  description = "Name of the frontend IP configuration."
  type        = string
}

variable "appgw_private" {
  description = "Boolean variable to create a private Application Gateway. When `true`, the default http listener will listen on private IP instead of the public IP."
  type        = bool
  default     = true
}

variable "private_ip_address" {
  type        = string
  description = "The private IP address of the Application Gateway. Must be within the range of the subnet"
  default     = "10.60.0.4"
}

variable "frontend_private_ip_configuration_name" {
  description = "Name of the frontend private IP configuration."
  type        = string
  default     = null
}

variable "frontend_port_settings" {
  description = "Frontend port settings. Each port setting contains the name and the port for the frontend port."
  type = list(object({
    name = string
    port = number
  }))
  default = []
}

variable "appgw_backend_pools" {
  description = "List of objects with backend pool configurations."
  type = list(object({
    name         = string
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
}

variable "appgw_backend_http_settings" {
  description = "List of objects including backend http settings configurations."
  type = list(object({
    name     = string
    port     = optional(number, 443)
    protocol = optional(string, "Https")

    path       = optional(string)
    probe_name = optional(string)

    cookie_based_affinity               = optional(string, "Disabled")
    affinity_cookie_name                = optional(string, "ApplicationGatewayAffinity")
    request_timeout                     = optional(number, 20)
    host_name                           = optional(string)
    pick_host_name_from_backend_address = optional(bool, true)
    trusted_root_certificate_names      = optional(list(string), [])
    authentication_certificate          = optional(string)

    connection_draining_timeout_sec = optional(number)
  }))
}

variable "appgw_http_listeners" {
  description = "List of objects with HTTP listeners configurations and custom error configurations."
  type = list(object({
    name = string

    frontend_ip_configuration_name = optional(string)
    frontend_port_name             = optional(string)
    host_name                      = optional(string)
    host_names                     = optional(list(string))
    protocol                       = optional(string, "Https")
    require_sni                    = optional(bool, false)
    ssl_certificate_name           = optional(string)
    ssl_profile_name               = optional(string)
    firewall_policy_id             = optional(string)

    custom_error_configuration = optional(list(object({
      status_code           = string
      custom_error_page_url = string
    })), [])
  }))
}

variable "appgw_routings" {
  description = "List of objects with request routing rules configurations. With AzureRM v3+ provider, `priority` attribute becomes mandatory."
  type = list(object({
    name                        = string
    rule_type                   = optional(string, "Basic")
    http_listener_name          = optional(string)
    backend_address_pool_name   = optional(string)
    backend_http_settings_name  = optional(string)
    url_path_map_name           = optional(string)
    redirect_configuration_name = optional(string)
    rewrite_rule_set_name       = optional(string)
    priority                    = optional(number)
  }))
}

variable "appgw_probes" {
  description = "List of objects with probes configurations."
  type = list(object({
    name     = string
    host     = optional(string)
    port     = optional(number, null)
    interval = optional(number, 30)
    path     = optional(string, "/")
    protocol = optional(string, "Https")
    timeout  = optional(number, 30)

    unhealthy_threshold                       = optional(number, 3)
    pick_host_name_from_backend_http_settings = optional(bool, false)
    minimum_servers                           = optional(number, 0)

    match = optional(object({
      body        = optional(string, "")
      status_code = optional(list(string), ["200-399"])
    }), {})
  }))
  default = []
}

variable "ssl_certificates_configs" {
  description = <<EOD
List of objects with SSL certificates configurations.
The path to a base-64 encoded certificate is expected in the 'data' attribute:
```
data = filebase64("./file_path")
```
EOD
  type = list(object({
    name                = string
    data                = optional(string)
    password            = optional(string)
    key_vault_secret_id = optional(string)
  }))
  default = []
}

variable "authentication_certificates_configs" {
  description = <<EOD
List of objects with authentication certificates configurations.
The path to a base-64 encoded certificate is expected in the 'data' attribute:
```
data = filebase64("./file_path")
```
EOD
  type = list(object({
    name = string
    data = string
  }))
  default = []
}

variable "trusted_client_certificates_configs" {
  description = <<EOD
List of objects with trusted client certificates configurations.
The path to a base-64 encoded certificate is expected in the 'data' attribute:
```
data = filebase64("./file_path")
```
EOD
  type = list(object({
    name = string
    data = string
  }))
  default = []
}

variable "trusted_root_certificate_configs" {
  description = "List of trusted root certificates. `file_path` is checked first, using `data` (base64 cert content) if null. This parameter is required if you are not using a trusted certificate authority (eg. selfsigned certificate)."
  type = list(object({
    name                = string
    data                = optional(string)
    file_path           = optional(string)
    key_vault_secret_id = optional(string)
  }))
  default = []
}

variable "user_assigned_identity_id" {
  description = "User assigned identity id assigned to this resource."
  type        = string
  default     = null
}

variable "enable_http2" {
  description = "Whether to enable http2 or not"
  type        = bool
  default     = true
}

variable "autoscaling_parameters" {
  description = "Map containing autoscaling parameters. Must contain at least min_capacity"
  type = object({
    min_capacity = number
    max_capacity = optional(number, 5)
  })
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
