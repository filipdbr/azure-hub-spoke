output "public_ip_web_servers" {
  value       = "http://${module.app_gw.app_gateway_public_ip}"
  description = "Please use the link in order to see the website"
}