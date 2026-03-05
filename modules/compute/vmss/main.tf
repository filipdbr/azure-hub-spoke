resource "azurerm_linux_virtual_machine_scale_set" "web_servers" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  sku = var.sku_name
  instances = 2
  admin_username = var.admin_name
  admin_password = var.admin_pwd
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = var.storage_type
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic-${var.name}-prod-pl"
    primary = true

    ip_configuration {
      name      = "default"
      primary   = true
      subnet_id = var.subnet_id
      application_gateway_backend_address_pool_ids = [var.application_gateway_backend_pool_id]
    }
  }

  custom_data = var.custom_data

  tags = var.tags
}