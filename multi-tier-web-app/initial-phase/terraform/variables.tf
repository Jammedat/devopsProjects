variable "resource_group_name" {
  description = "The name of the resource group where the resources will be created."
  type        = string

}

variable "location" {
  description = "The Azure region where the resources will be deployed."
  type        = string
  default     = "East US"

}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string


}


