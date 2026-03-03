resource "azurerm_virtual_network_peering" "vnet1-to-vnet2" {
  name                      = "peer-${var.vnet1_name_hub}-to-${var.vnet2_name_spoke}"
  resource_group_name       = var.vnet1_rg_name_hub
  virtual_network_name      = var.vnet1_name_hub
  remote_virtual_network_id = var.vnet2_id_spoke
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
}

resource "azurerm_virtual_network_peering" "vnet2-to-vnet1" {
  name                      = "peer-${var.vnet2_name_spoke}-to-${var.vnet1_name_hub}"
  resource_group_name       = var.vnet2_rg_name_spoke
  virtual_network_name      = var.vnet2_name_spoke
  remote_virtual_network_id = var.vnet1_id_hub
  allow_forwarded_traffic   = true
  use_remote_gateways       = true
}