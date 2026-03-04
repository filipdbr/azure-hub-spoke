# public IP for the gateway
resource "azurerm_public_ip" "vpn_gateway" {
  name                = "pip-${var.vpn_gateway_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# VPN / Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "office" {
  name                = var.vpn_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = true
  enable_bgp          = false
  sku                 = "VpnGw1"

  ip_configuration {
    name                          = "vpn_gateway_ip_config"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gateway_subnet_id
  }
}

# local network gateway (office)
resource "azurerm_local_network_gateway" "office" {
  name                = "local-gateway-office-${var.office_city}"
  location            = var.location
  resource_group_name = var.resource_group_name
  gateway_address     = var.pip_office
  address_space       = var.office_address_space
}

# tunnel between the office and cloud
resource "azurerm_virtual_network_gateway_connection" "vpn_connection" {
  name                       = "connection_${var.vpn_gateway_name}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.office.id
  local_network_gateway_id   = azurerm_local_network_gateway.office.id
  shared_key                 = var.shared_key
}