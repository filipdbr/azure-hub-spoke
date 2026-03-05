output "public_ip_web_servers" {
  value       = "http://${module.app_gw.app_gateway_public_ip}"
  description = "Please use the link in order to see the website"
}

output "private_ips_web_servers" {
  value = module.web_servers.web_servers_ips
}