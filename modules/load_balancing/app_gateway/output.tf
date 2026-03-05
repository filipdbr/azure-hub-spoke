# backend address pull is a set by defult. Conversion to list in order to get the element using index.
output "backend_address_pool_id" {
  value = tolist(azurerm_application_gateway.web.backend_address_pool)[0].id
}

output "app_gateway_public_ip" {
  value = azurerm_public_ip.appgw.ip_address
}