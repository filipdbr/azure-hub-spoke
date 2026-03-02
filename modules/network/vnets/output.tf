output "vnet_name" {
  value = azurerm_virtual_network.default.name
}

output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "subnets" {
  value       = azurerm_subnet.default
  description = "Map of created subnets"
}

output "rg" {
  value = azurerm_virtual_network.default.resource_group_name
}