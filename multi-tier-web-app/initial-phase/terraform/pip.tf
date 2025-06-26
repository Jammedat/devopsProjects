
resource "azurerm_public_ip" "db" {
  name = "db-pip"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location
  allocation_method = "Static"
  sku = "Standard"
  
}

# resource "azurerm_public_ip" "mc" {
#   name = "mc-pip"
#   resource_group_name = azurerm_resource_group.example.name
#   location = azurerm_resource_group.example.location
#   allocation_method = "Static"
#   sku = "Standard"
  
# }

# resource "azurerm_public_ip" "rmq" {
#   name = "rmq-pip"
#   resource_group_name = azurerm_resource_group.example.name
#   location = azurerm_resource_group.example.location
#   allocation_method = "Static"
#   sku = "Standard"
  
# }
