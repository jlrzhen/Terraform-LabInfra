# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

module "subnet-deployment" {
  source = "./modules/subnet-deployment"
  resource_group_name = azurerm_resource_group.example.name
  resource_group_location = azurerm_resource_group.example.location
  virtual_network_name = azurerm_virtual_network.example.name
  prefix_count = "1"
  inbound_ports = ["22"]
  outbound_ports = ["0-65535"]
  hosts = {
    "host1" = var.ubuntu,
    "host2" = var.ubuntu,
    "host3" = var.ubuntu,
    "control" = var.ubuntu
  }
}
