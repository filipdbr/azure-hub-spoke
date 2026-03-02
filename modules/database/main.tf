# set up a SQL server (instance)
resource "azurerm_mssql_server" "default" {
  name                          = var.server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.admin_login
  administrator_login_password  = var.admin_pwd
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false
  tags                          = var.tags
}

# create a default DB
resource "azurerm_mssql_database" "default" {
  name         = var.db_name
  server_id    = azurerm_mssql_server.default.id
  collation    = var.collation
  license_type = "BasePrice"
  max_size_gb  = 1
  sku_name     = "Basic"
}

# create a private endpoint
resource "azurerm_private_endpoint" "db" {
  name                = "private-endpoint-${var.db_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.db_subnet_id

  private_service_connection {
    name                           = "sql-privatelink"
    private_connection_resource_id = azurerm_mssql_server.default.id
    subresource_names              = ["SQLserver"]
    is_manual_connection           = false
  }
}

# create a private DNS zone for the DB
resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
}

# set up a link to DNS zone 
resource "azurerm_private_dns_zone_virtual_network_link" "db_dns_link" {
  name = "sql-dns-link"
  resource_group_name = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id = var.vnet_id
}

# add a DB record to the DNS
resource "azurerm_private_dns_a_record" "db_record" {
  name = var.server_name
  zone_name = azurerm_private_dns_zone.sql.name
  resource_group_name = var.resource_group_name
  ttl = 300
  records = [azurerm_private_endpoint.db.private_service_connection[0].private_ip_address]
}