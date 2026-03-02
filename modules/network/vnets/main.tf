# the module will create vnets and subnets defined in vnets.tf in the root directory
resource "azurerm_virtual_network" "default" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "default" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = azurerm_virtual_network.default.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = [each.value.address]
  service_endpoints    = each.value.endpoints
}