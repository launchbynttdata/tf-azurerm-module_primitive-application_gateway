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

module "resource_names" {
  source = "git::https://github.com/launchbynttdata/tf-launch-module_library-resource_name.git?ref=1.0.1"

  for_each = var.resource_names_map

  logical_product_family  = var.product_family
  logical_product_service = var.product_service
  region                  = join("", split("-", var.region))
  class_env               = var.environment
  cloud_resource_type     = each.value.name
  instance_env            = var.environment_number
  instance_resource       = var.resource_number
  maximum_length          = each.value.max_length
  use_azure_region_abbr   = true

}

module "resource_group" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-resource_group.git?ref=1.0.0"

  location = var.region
  name     = module.resource_names["resource_group"].standard

  tags = merge(var.tags, { resource_name = module.resource_names["resource_group"].standard })
}

module "public_ip" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-public_ip?ref=1.0.0"

  name                = module.resource_names["public_ip"].standard
  resource_group_name = module.resource_group.name
  location            = var.region
  allocation_method   = "Static"
  domain_name_label   = module.resource_names["public_ip"].standard
  sku                 = "Standard"
  sku_tier            = "Regional"
  zones               = var.zones

  tags = merge(var.tags, {
    resource_name = module.resource_names["public_ip"].standard
  })

  depends_on = [module.resource_group]
}

module "vnet" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-virtual_network.git?ref=2.0.0"

  resource_group_name                                  = module.resource_group.name
  vnet_name                                            = module.resource_names["vnet"].standard
  vnet_location                                        = var.region
  address_space                                        = var.address_space
  subnet_names                                         = var.subnet_names
  subnet_prefixes                                      = var.subnet_prefixes
  bgp_community                                        = null
  ddos_protection_plan                                 = null
  dns_servers                                          = []
  nsg_ids                                              = {}
  route_tables_ids                                     = {}
  subnet_delegation                                    = {}
  subnet_private_endpoint_network_policies_enabled     = {}
  subnet_private_link_service_network_policies_enabled = {}
  subnet_service_endpoints                             = {}
  tags                                                 = merge(var.tags, { resource_name = module.resource_names["vnet"].standard })
  use_for_each                                         = true


  depends_on = [module.resource_group]
}

module "application_gateway" {
  source = "../.."

  name                                   = module.resource_names["app_gateway"].standard
  location                               = var.region
  resource_group_name                    = module.resource_group.name
  frontend_ip_configuration_name         = var.frontend_ip_configuration_name
  public_ip_address_id                   = module.public_ip.id
  frontend_private_ip_configuration_name = var.frontend_private_ip_configuration_name
  gateway_ip_configuration_name          = var.gateway_ip_configuration_name
  sku                                    = var.sku
  sku_capacity                           = var.sku_capacity
  zones                                  = var.zones
  frontend_port_settings                 = var.frontend_port_settings
  trusted_client_certificates_configs    = var.trusted_client_certificates_configs
  trusted_root_certificate_configs       = var.trusted_root_certificate_configs
  appgw_backend_pools                    = var.appgw_backend_pools
  appgw_http_listeners                   = var.appgw_http_listeners
  appgw_routings                         = var.appgw_routings
  appgw_probes                           = var.appgw_probes
  appgw_backend_http_settings            = var.appgw_backend_http_settings
  subnet_id                              = module.vnet.vnet_subnets[0]
  user_assigned_identity_id              = var.user_assigned_identity_id
  appgw_private                          = var.appgw_private
  appgw_private_ip                       = var.private_ip_address
  enable_http2                           = var.enable_http2
  autoscaling_parameters                 = var.autoscaling_parameters
  ssl_certificates_configs               = var.ssl_certificates_configs
  authentication_certificates_configs    = var.authentication_certificates_configs

  tags = merge(var.tags, {
    resource_name = module.resource_names["app_gateway"].standard
  })

  depends_on = [module.resource_group, module.public_ip, module.vnet]
}
