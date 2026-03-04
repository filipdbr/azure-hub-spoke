# order a vnet for hub
module "hub_vnet" {
  source              = "./modules/network/vnets"
  name                = "vnet-prod-pl-hub"
  resource_group_name = azurerm_resource_group.hub.name
  location            = var.location
  address_space       = ["10.1.0.0/16"]
  tags                = local.shared_tags

  subnets = {
    "AzureBastionSubnet"  = { address = "10.1.1.0/26", endpoints = [] }
    "GatewaySubnet"       = { address = "10.1.2.0/27", endpoints = [] }
    "AzureFirewallSubnet" = { address = "10.1.3.0/26", endpoints = [] }
  }
}

# order a vnet for spoke
module "spoke_vnet" {
  source              = "./modules/network/vnets"
  name                = "vnet-prod-pl-spoke"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = var.location
  address_space       = ["10.2.0.0/16"]
  tags                = local.shared_tags

  # initally the idea was to add a service endpoint for SQL db
  # as later I decided to change to a private endpoint, the endpoints lists are empty
  subnets = {
    "snet-prod-pl-appgw" = { address = "10.2.1.0/24", endpoints = [] }
    "snet-prod-pl-web"   = { address = "10.2.2.0/24", endpoints = [] }
    "snet-prod-pl-app"   = { address = "10.2.3.0/24", endpoints = [] }
    "snet-prod-pl-db"    = { address = "10.2.4.0/24", endpoints = [] }
  }
}

# set up peering
module "peering" {
  source = "./modules/network/peering"

  # vnet 1 : hub
  vnet1_name_hub    = module.hub_vnet.vnet_name
  vnet1_id_hub      = module.hub_vnet.vnet_id
  vnet1_rg_name_hub = module.hub_vnet.rg

  # vnet 2 : spoke
  vnet2_name_spoke    = module.spoke_vnet.vnet_name
  vnet2_id_spoke      = module.spoke_vnet.vnet_id
  vnet2_rg_name_spoke = module.spoke_vnet.rg
}

# set up routing to firewall
module "routing" {
  source              = "./modules/network/routing"
  route_table_name    = "rt-prod-pl-spoke"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location
  firewall_private_ip = module.firewall.private_ip_address

  subnets_ids = {
    "web" = module.spoke_vnet.subnets["snet-prod-pl-web"].id,
    "app" = module.spoke_vnet.subnets["snet-prod-pl-app"].id
  }
}