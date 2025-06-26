
resource "azurerm_linux_virtual_machine" "db" {
  name                = "db-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.db.id,
  ]
  custom_data = filebase64("../userdata/mysql.tpl")

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")

  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer = "almalinux-x86_64"
    publisher = "almalinux"
    sku = "9-gen2"
    version = "latest"
  }
}


resource "azurerm_linux_virtual_machine" "mc" {
  name                = "mc-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.mc.id,
  ]

  custom_data = filebase64("../userdata/memecache.tpl")

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")

  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer = "almalinux-x86_64"
    publisher = "almalinux"
    sku = "9-gen2"
    version = "latest"
  }
}


resource "azurerm_linux_virtual_machine" "rmq" {
  name                = "rmq-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.rmq.id,
  ]

  custom_data = filebase64("../userdata/rabbitmq.tpl")

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")

  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer = "almalinux-x86_64"
    publisher = "almalinux"
    sku = "9-gen2"
    version = "latest"
  }
}
