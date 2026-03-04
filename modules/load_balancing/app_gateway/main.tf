# create a public IP for the app gateway
# in a production env we could consider ddos protection for this pip
# however it's very expensive and app gateway provides us with enough secuirty for this project
resource "azurerm_public_ip" "appgw" {
  name                = var.pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard" # as appgw will be in a standard version, standard IP is necessary
}

resource "azurerm_application_gateway" "web" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  # autoscaling for HA
  autoscale_configuration {
    min_capacity = 1
    max_capacity = 2
  }

  gateway_ip_configuration {
    name      = "${var.name}-ip-config"
    subnet_id = var.subnet_id
  }

  # port 80 for a simple config, would be 443 in a real env
  # port 443 requires a certificate and way more complex config
  frontend_port {
    name = "${var.name}-front-end-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "${var.name}-front-ip-config"
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  # empty as VMSS is deployed and the process is autmated
  backend_address_pool {
    name = "${var.name}-backend-address-pool"
  }

  # cookie based affinity aka. sticky sessions are not needed in our project
  backend_http_settings {
    name                  = "${var.name}-backend-http-setting"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    cookie_based_affinity = "Disabled"
    probe_name = "hp-web-app-status"
    pick_host_name_from_backend_address = true
  }

  probe {
    name                = "hp-web-app-status"
    protocol            = "Http"
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    # mandatory for VMSS 
    pick_host_name_from_backend_http_settings = true
  }

  http_listener {
    name                           = "${var.name}-http-listener"
    frontend_ip_configuration_name = "${var.name}-front-ip-config"
    frontend_port_name             = "${var.name}-front-end-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${var.name}-request-routing-rule"
    rule_type                  = "Basic"
    priority                   = 100
    http_listener_name         = "${var.name}-http-listener"
    backend_address_pool_name  = "${var.name}-backend-address-pool"
    backend_http_settings_name = "${var.name}-backend-http-setting"
  }
}