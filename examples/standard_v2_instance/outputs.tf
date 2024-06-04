output "app_gateway_id" {
  value = module.application_gateway.id
}

output "app_gateway_name" {
  value = module.application_gateway.name
}

output "frontend_ip_configuration" {
  value = module.application_gateway.frontend_ip_configuration
}

output "frontend_port" {
  value = module.application_gateway.frontend_port
}

output "backend_address_pool" {
  value = module.application_gateway.backend_address_pool
}
