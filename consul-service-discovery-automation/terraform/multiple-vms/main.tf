
# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "example" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create a subnet
resource "azurerm_subnet" "example" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP 
resource "azurerm_public_ip" "example" {
  for_each                = toset(var.vm_names)  # Assuming var.vm_namess is a list of VM names
  name                    = "${each.key}-ip"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
}

# Create a network security group
resource "azurerm_network_security_group" "example" {
  name                = var.network_security_group_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "inbound-ports"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80", "8500", "8300-8302", "8600"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
}

# Associate the network security group with the subnet
resource "azurerm_network_interface_security_group_association" "example" {
  for_each                    = toset(var.vm_names)
  network_interface_id        = azurerm_network_interface.example[each.key].id # Assuming var.vm_namess is a list of VM names
  network_security_group_id   = azurerm_network_security_group.example.id
}



# Create a network interface
resource "azurerm_network_interface" "example" {
  for_each            = toset(var.vm_names)  # Assuming var.vm_namess is a list of VM names
  name                = "${each.key}-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example[each.key].id
  }
  }


# Create a virtual machine
resource "azurerm_linux_virtual_machine" "example" {
  for_each = toset(var.vm_names)  # Assuming var.vm_namess is a list of VM names
  name                = each.key
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1s"  # Equivalent to AWS t2.micro
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.example[each.key].id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")  # Path to your public SSH key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

data "azurerm_public_ip" "example" {
  for_each            = toset(var.vm_names)
  name                = azurerm_public_ip.example[each.key].name
  resource_group_name = azurerm_linux_virtual_machine.example[each.key].resource_group_name
}