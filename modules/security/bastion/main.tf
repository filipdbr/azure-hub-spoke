# create a public IP for bastion
resource "azurerm_public_ip" "bastion" {
  name = "pip-${var.name_bastion}"
  resource_group_name = var.resource_group_name
  location = var.location
  allocation_method = "Static"
  sku = "Standard"
  tags = var.tags
}

# create bastion host
resource "azurerm_bastion_host" "hub" {
  name = var.name_bastion
  resource_group_name = var.resource_group_name
  location = var.location

  ip_configuration {
    name = "ip-config-${var.name_bastion}"
    subnet_id = var.subnet_id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }

  tags = var.tags
}