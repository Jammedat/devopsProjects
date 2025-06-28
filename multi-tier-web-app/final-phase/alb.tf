data "azurerm_resource_group" "demo" {
  name = "multi-tier-app"

}

resource "azurerm_public_ip" "lb_pip" {
  name                = "lb-pip"
  location            = data.azurerm_resource_group.demo.location
  resource_group_name = data.azurerm_resource_group.demo.name
  allocation_method   = "Static"
  sku                 = "Standard"

}

resource "azurerm_lb" "lb" {
  name                = "lb"
  location            = data.azurerm_resource_group.demo.location
  resource_group_name = data.azurerm_resource_group.demo.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicFrontend"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }

}

resource "azurerm_lb_backend_address_pool" "tomcat_backend" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.lb.id

}

# resource "azurerm_lb_backend_address_pool_address" "tomcat" {
#   name = "tomcat"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.tomcat_backend.id
#   virtual_network_id = data.azurerm_virtual_network.tomcat.id
#   ip_address = azurerm_network_interface.tomcat.private_ip_address
  
# }

resource "azurerm_lb_probe" "tomcat_probe" {
  name             = "health-probe"
  loadbalancer_id  = azurerm_lb.lb.id
  protocol         = "Tcp"
  port             = 8080
  number_of_probes = 2
  interval_in_seconds = 5

}

resource "azurerm_lb_rule" "http_rule" {
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8080
  frontend_ip_configuration_name = "PublicFrontend"
  loadbalancer_id                = azurerm_lb.lb.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.tomcat_backend.id]
  probe_id                       = azurerm_lb_probe.tomcat_probe.id
}
