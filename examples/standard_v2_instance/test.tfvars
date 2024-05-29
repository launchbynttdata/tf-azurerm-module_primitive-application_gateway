frontend_port_settings = [
  {
    name = "port_80"
    port = 80
  },
  {
    name = "port_443"
    port = 443
  }
]

appgw_backend_pools = [
  {
    name         = "apim_backend_pool"
    ip_addresses = ["10.60.0.20"]
  }
]

appgw_routings = [
  {
    name                       = "apim_routing"
    backend_address_pool_name  = "apim_backend_pool"
    backend_http_settings_name = "apim_backend_http_settings"
    http_listener_name         = "http_listener"
    #url_path_map_name    = "url_path_map"
    priority = 100
  }
]

appgw_http_listeners = [
  {
    name               = "http_listener"
    frontend_port_name = "port_80"
    protocol           = "Http"
  }
]

appgw_backend_http_settings = [
  {
    name                                = "apim_backend_http_settings"
    cookie_based_affinity               = "Disabled"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 20
    pick_host_name_from_backend_address = true
  }
]

frontend_ip_configuration_name         = "standard-frontend-ip"
frontend_private_ip_configuration_name = "standard-private-ip"
gateway_ip_configuration_name          = "app-gateway-ip"
