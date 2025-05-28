# Define an output variable for the public IP address
output "public_ip_address" {
  value = data.azurerm_public_ip.example.ip_address
  
}