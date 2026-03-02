module "app_gw" {
  source              = "./modules/load_balancing/app_gateway"
  name                = "appgw-prod-pl-spoke"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location
  subnet_id           = module.spoke_vnet.subnets["snet-prod-pl-appgw"].id
  pip_name            = "pip-appgw"
  # additional tag as the config of this resources is a bit challenging
  tags = merge(local.shared_tags, {
    "Complexity" = "Complex"
  })
}

module "internal_lb_app" {
  source              = "./modules/load_balancing/internal_lb_app"
  name                = "ilb-prod-pl-app"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location
  subnet_id           = module.spoke_vnet.subnets["snet-prod-pl-app"].id
}

# associate VMs with backend pool for and app internal load balancer
resource "azurerm_network_interface_backend_address_pool_association" "app_tier" {
  # use the output of /modules/compute/app_servers - number of VMs
  count                   = length(module.app_servers.app_nic_ids)
  network_interface_id    = module.app_servers.app_nic_ids[count.index]
  ip_configuration_name   = module.app_servers.app_ip_config_names[count.index]
  backend_address_pool_id = module.internal_lb_app.backend_address_pool_id
}