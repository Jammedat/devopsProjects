# Define an input variable for resource group name
variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type = string
}

variable "location" {
  description = "The location in which the resources will be created."
  type = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network."
  type = string
  
}

variable "subnet_name" {
  description = "The name of the subnet."
  type = string
  
}

variable "network_interface_name" {
  description = "The name of the network interface."
  type = string
  
}

variable "network_security_group_name" {
  description = "The name of the network security group."
  type = string
  
}

variable "vm_name" {
  description = "The name of the virtual machine."
  type = string
  
}

variable "public_ip_name" {
  description = "The name of the public IP address."
  type = string
  
}