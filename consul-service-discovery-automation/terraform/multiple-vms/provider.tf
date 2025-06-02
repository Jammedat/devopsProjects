terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.41.0"
    }
  }

  required_version = ">= 1.2.0"
}

#Configure the Azure Provider
provider "azurerm" {
  features {}
}
