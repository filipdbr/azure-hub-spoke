output "web_servers_id" {
  value = azurerm_linux_virtual_machine_scale_set.web_servers.id
}

output "web_servers_ips" {
  value = azurerm_linux_virtual_machine_scale_set.web_servers.network_interface[*].ip_configuration[0].private_ip_address
  description = "list of pivate IPs of machines in VMSS"
}