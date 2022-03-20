variable "resource_group_name" {
  default = "LabTFResourceGroup"
}

variable "resource_group_location" {
  default = "eastus"
}

variable "hosts" {
  default = {
    "Larry" = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    },
    "Curly" = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
  }
}

variable "virtual_network_name" {
}

variable "prefix_count" {
}

variable "inbound_ports" {
}

variable "outbound_ports" {
}

