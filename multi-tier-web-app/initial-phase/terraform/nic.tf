
resource "azurerm_network_interface" "db" {
  name                = "db-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.db.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.db.id
  }

}

resource "azurerm_network_interface" "mc" {
  name                = "mc-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mc.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id = azurerm_public_ip.mc.id
  }

}

resource "azurerm_network_interface" "rmq" {
  name                = "rmq-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.rmq.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id = azurerm_public_ip.rmq.id
  }

}