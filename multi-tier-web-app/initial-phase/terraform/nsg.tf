
resource "azurerm_network_security_group" "backends" {
  name                = "backends-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "mysql"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["3306"]
    source_address_prefix      = "10.0.4.0/24" #Subnet assosiated with tomcat vm
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "memcached"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["11211"]
    source_address_prefix      = "10.0.4.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "rmq"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["5672"]
    source_address_prefix      = "10.0.4.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allowssh"
    priority                   = 115
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.backends.id

}

resource "azurerm_subnet_network_security_group_association" "mc" {
  subnet_id                 = azurerm_subnet.mc.id
  network_security_group_id = azurerm_network_security_group.backends.id

}

resource "azurerm_subnet_network_security_group_association" "rmq" {
  subnet_id                 = azurerm_subnet.rmq.id
  network_security_group_id = azurerm_network_security_group.backends.id

}

