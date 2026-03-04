# Comment: provisioning VPN Gateway takes ~30-45 minutes
# This module is commented out by default. To deploy, uncomment the block below.
# Detailed instructions can be found in the project README

/*
module "vpn_gateway" {
  source              = "./modules/network/vpn"
  location            = var.location
  resource_group_name = module.hub_rg.name
  vpn_gateway_name    = "vgw-prod-pl-hub"
  gateway_subnet_id   = module.hub_vnet.gateway_subnet_id

  # office data / completely fictional 
  # you can put your own
  office_city          = var.office_city
  pip_office           = var.pip_office
  office_address_space = var.office_address_space

  # Bezpieczeństwo
  shared_key = var.shared_key_vpn
}
*/