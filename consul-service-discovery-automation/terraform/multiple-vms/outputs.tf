# Define an output variable for the public IP address
output "public_ip_address" {
  value = {
    for vm in var.vm_names :
    vm => data.azurerm_public_ip.example[vm].ip_address
  }
  
}