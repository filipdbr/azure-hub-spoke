module "web_servers" {
  source                              = "./modules/compute/vmss"
  name                                = "vmss-prod-pl-web"
  location                            = azurerm_resource_group.spoke.location
  resource_group_name                 = azurerm_resource_group.spoke.name
  sku_name                            = var.vmss_size
  admin_pwd                           = var.vmss_admin_pwd
  custom_data                         = filebase64("${path.module}/scripts/web_config.sh")
  storage_type                        = var.storage_account_type
  subnet_id                           = module.spoke_vnet.subnets["snet-prod-pl-web"].id
  tags                                = local.shared_tags
  application_gateway_backend_pool_id = module.app_gw.backend_address_pool_id
}

module "app_servers" {
  source              = "./modules/compute/app_servers"
  names               = ["vm-prod-pl-app-01", "vm-prod-pl-app-02"]
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  subnet_id           = module.spoke_vnet.subnets["snet-prod-pl-app"].id
  size                = var.app_server_size
  admin_pwd           = var.app_servers_admin_pwd
  # would be possible to define os_disk and but I will go with default settings
  # default settings are to be found in moules/compute/app_servers
}