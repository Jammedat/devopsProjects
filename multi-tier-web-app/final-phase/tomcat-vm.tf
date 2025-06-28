# resource "azurerm_public_ip" "tomcat" {
#   name                = "tomcat-pip"
#   resource_group_name = data.azurerm_resource_group.demo.name
#   location            = data.azurerm_resource_group.demo.location
#   allocation_method   = "Static"
#   sku                 = "Standard"

# }

data "azurerm_virtual_network" "tomcat" {
  name                = "example-vnet"
  resource_group_name = "multi-tier-app"

}

resource "azurerm_subnet" "tomcat" {
  name                 = "tomcat-subnet"
  resource_group_name  = data.azurerm_resource_group.demo.name
  virtual_network_name = data.azurerm_virtual_network.tomcat.name
  address_prefixes     = ["10.0.4.0/24"]

}

resource "azurerm_network_interface" "tomcat" {
  name                = "tomcat-nic"
  resource_group_name = data.azurerm_resource_group.demo.name
  location            = data.azurerm_resource_group.demo.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tomcat.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.tomcat.id
  }

}

resource "azurerm_network_security_group" "tomcat" {
  name                = "tomcat-nsg"
  location            = data.azurerm_resource_group.demo.location
  resource_group_name = data.azurerm_resource_group.demo.name
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "8080"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "tomcat" {
  subnet_id                 = azurerm_subnet.tomcat.id
  network_security_group_id = azurerm_network_security_group.tomcat.id
}

# resource "azurerm_linux_virtual_machine" "tomcat" {
#   name                = "tomcat-vm"
#   resource_group_name = data.azurerm_resource_group.demo.name
#   location            = data.azurerm_resource_group.demo.location
#   size                = "Standard_B1s"
#   admin_username      = "azureuser"
#   network_interface_ids = [
#     azurerm_network_interface.tomcat.id,
#   ]

#   custom_data = filebase64("deploy-tomcat.tpl")

#   admin_ssh_key {
#     username   = "azureuser"
#     public_key = file("~/.ssh/id_rsa.pub")

#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts"
#     version   = "latest"
#   }
# }


resource "azurerm_linux_virtual_machine_scale_set" "tomcat" {
  name                = "tomcat-vmss"
  resource_group_name = data.azurerm_resource_group.demo.name
  location            = data.azurerm_resource_group.demo.location
  sku                 = "Standard_B1s"
  instances           = 2
  admin_username      = "azureuser"
  
  custom_data = filebase64("deploy-tomcat.tpl")

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.tomcat.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.tomcat_backend.id]
    }
  }
}